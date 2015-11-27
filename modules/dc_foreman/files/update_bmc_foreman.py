#!/usr/bin/env python
"""
Script to add and configure BMC interface in Foreman
"""

import sys
import dc_foreman
import subprocess
import os
import socket
import ConfigParser

def find_lan_channel():
    """
    Find the IPMI Lan Channel
    """
    for channel in range(1, 3):
        devnull = open(os.devnull, 'r+b', 0)
        returncode = subprocess.call(['/usr/bin/ipmitool', 'lan', 'print',
                                      str(channel)], stdin=devnull,
                                     stdout=devnull, stderr=devnull)
        if returncode == 0:
            return channel
    print "Could not find IPMI lan channel"
    sys.exit(1)

def get_ipmi_mac(ipmi_lan_chan):
    """
    Get MAC address of IPMI
    """
    command = '/usr/bin/ipmitool lan print %s | grep \'MAC Address\' \
                | awk \'{print $4}\'' % ipmi_lan_chan
    mac = subprocess.check_output(command, shell=True).strip()
    return mac

def get_ipmi_ip(ipmi_lan_chan):
    """
    Get IP address of IPMI
    """
    command = '/usr/bin/ipmitool lan print %s | grep \'IP Address  \' \
                | awk \'{print $4}\'' % ipmi_lan_chan
    ip_address = subprocess.check_output(command, shell=True).strip()
    return ip_address

def main():
    """
    Updates BMC config in Foreman
    Expects config file in ini format eg.

    [foreman]
    foreman_api_user = some_user
    foreman_api_pw = some_password
    foreman_api_baseurl = https://foreman-server/api/v2/
    cert_path = a_cert
    cacert_path = a_cacert
    key_path = a_key

    [bmc]
    bmc_subnet = a_subnet
    bmc_user = a_bmc_user
    bmc_password = a_bmc_pass
    """
    configfile = '/usr/local/etc/update_bmc.config'

    try:
        parser = ConfigParser.SafeConfigParser()
        parser.read(configfile)
    except ConfigParser.ParsingError, err:
        print 'Could not parse config file:', err
        sys.exit(1)

    # Create a Foreman object
    foreman_server = dc_foreman.Foreman(configfile)

    # Check we can reach the Foreman API
    foreman_server.check_api_endpoint()

    # Check if the interface is defined in Foreman
    # exit if it isn't and wait for puppet to create it
    bmc_int = [interface for interface in
               foreman_server.get_from_api('hosts/' + \
                       socket.getfqdn() + '/interfaces?per_page=10000')
               if interface['type'] == 'bmc'][0]
    if not bmc_int:
        print "Interface not defined in Foreman"
        sys.exit(1)

    # Get the variables we need to start configuring things
    subnet_info, domain = foreman_server.find_subnet_info(parser.get
                                                          ('bmc',
                                                           'bmc_subnet'))
    host_id = foreman_server.get_host_id(socket.getfqdn())
    payload = {'interface': {'identifier': 'ipmi',
                             'type': 'bmc', 'managed': 'true',
                             'name': socket.getfqdn().split('.')[0] + '-bmc',
                             'ip': get_ipmi_ip(find_lan_channel()),
                             'mac': get_ipmi_mac(find_lan_channel()),
                             'username': parser.get('bmc', 'bmc_user'),
                             'password': parser.get('bmc', 'bmc_password'),
                             'provider': 'IPMI', 'domain_id': domain[0],
                             'subnet_id': subnet_info['id'],
                             'host_id': host_id}}
    foreman_server.put_to_api('hosts/' + \
            str(host_id) + '/interfaces/' + str(bmc_int['id']), payload)

    print "BMC configuration complete"


if __name__ == "__main__":
    main()
