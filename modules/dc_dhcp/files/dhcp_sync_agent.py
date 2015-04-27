#!/usr/bin/env python
"""
DHCP failover for static leases

Rudimentary script to detect changes to dhcp leases on the primary
server, extract static leases and synchronise them to the secondary
server.

Note: Does not do anything clever like lazy updates, each modification
to the dhcp.leases file will cause a synchronisation and service restart
on the secondary server.  Keep it simple, keep it safe!
"""

import re
import sys
import getopt
import logging
import tempfile
import pyinotify
import subprocess

class DHCPLeaseListener(pyinotify.ProcessEvent):
    """
    Class to process inotify events
    """

    def process_IN_CLOSE_WRITE(self, event):
        """
        Function to process IN_CLOSE_WRITE events
        """

        # Pull out the static leases
        leases_file = open('/var/lib/dhcp/dhcpd.leases', 'r')
        lines = leases_file.readlines()
        leases_file.close()
        in_host = False
        static_leases = []
        for line in lines:
            if re.match('^host', line):
                in_host = True
            if in_host:
                static_leases.append(line)
            if re.match('^}', line):
                in_host = False

        # Spit them out to a temporary file
        temp_file = tempfile.NamedTemporaryFile()
        temp_file.write(''.join(static_leases))
        temp_file.flush()

        # Send to the secondary and restart the daemon
        try:
            cmd = ['scp', temp_file.name, '{0}:/tmp/dhcpd.hosts'.format(HOST)]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            logging.error('Unable to transfer static leases to remote host')
        try:
            cmd = ['ssh', HOST, '/usr/local/bin/dhcp_sync_hosts.sh']
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            logging.error('Unable to run dhcp_sync_hosts')

        # Clean up the temporary file
        temp_file.close()


def usage():
    """
    Print the script arguments
    """
    print 'dhcp_sync_agent.py -h <hostname>'

def main(argv):
    """
    Option parsing and main event loop
    """

    logging.info('Starting dhcp synchronisation agent ...')

    # Parse and validate options
    global HOST
    logging.info('Parsing command line parameters ...')
    try:
        opts, dummy = getopt.getopt(argv, 'h:', ['host='])
    except getopt.GetoptError:
        logging.error('Unable to parse options')
        usage()
        sys.exit(1)

    for opt, arg in opts:
        if opt in ['-h', '--host']:
            HOST = arg
            break
    else:
        logging.error('Remote host not specified')
        usage()
        sys.exit(1)

    # Begin monitoring the dhcp leases file and dispatch events
    # to our listener class
    watch = pyinotify.WatchManager()
    mask = pyinotify.IN_CLOSE_WRITE
    notifier = pyinotify.Notifier(watch, DHCPLeaseListener())
    watch.add_watch('/var/lib/dhcp', mask)

    logging.info('Entering event loop ...')
    while True:
        try:
            notifier.process_events()
            if notifier.check_events():
                notifier.read_events()
        except KeyboardInterrupt:
            logging.info('Received SIGINT, shutting down')
            notifier.stop()
            break

if __name__ == '__main__':

    HOST = ""

    logging.basicConfig(level=logging.INFO,
        filename="/var/log/dhcp_sync_agent.log",
        format='[%(asctime)-8s] %(levelname)s: %(message)s'
    )

    main(sys.argv[1:])

# vi: ts=4 noet:

