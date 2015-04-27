#!/usr/bin/env python
"""
Script to check Foreman data against network services
Requires the dc_foreman and dc_omapi python modules
"""
import sys
import socket
import os
import ConfigParser
import dc_foreman
import dc_omapi
from pypureomapi import OmapiErrorNotFound
import dc_dhcp_parser

# Look up hostname in DNS
def dns_lookup(name):
    """
    Look up hostname in DNS
    """
    try:
        ip_addr = socket.gethostbyname(name)
        return ip_addr
    except socket.gaierror:
        raise

def get_host_list(lease_file):
    """
    Return a sensibly formatted list of hosts in DHCP
    """
    host_list = []
    host_parser = dc_dhcp_parser.DhcpHostsParser(lease_file)
    host_parser.parse()
    hosts = host_parser.get_hosts()
    for host in hosts:
        host_list.append({
                'name':host[0].lease_name,
                'ip':host[0].ip_addresses,
                'mac':host[0].mac_address})
    return host_list


############################################

def main():
    """
    Check proxy config against Foreman
    Expects config file in ini format eg.

    [foreman]
    foreman_admin_user = some_user
    foreman_admin_pw = some_password
    foreman_api_baseurl = https://foreman-server/api/v2/
    cert_path = a_cert
    cacert_path = a_cacert
    key_path = a_key

    [omapi]
    omapi_port = 7911
    omapi_key = some_key
    omapi_secret = some_secret
    dhcp_server = 127.0.0.1

    [tftp]
    pxe_root = /var/tftpboot/pxelinux.cfg

    """
    configfile = '/usr/local/etc/foreman_check.config'

    try:
        parser = ConfigParser.SafeConfigParser()
        parser.read(configfile)
    except ConfigParser.ParsingError, err:
        print 'Could not parse config file:', err
        sys.exit(1)
    pxe_root = parser.get('pxe', 'pxe_root')

    # Create a Foreman object
    foreman_server = dc_foreman.Foreman(configfile)

    # Check we can reach the Foreman API
    foreman_server.check_api_endpoint()

    failures = []

    # Load a dictionary with all of the defined interfaces in Foreman
    ints = foreman_server.load_interfaces()

    # Create an OMAPI Wrapper object
    omapi_wrapper = dc_omapi.OmapiWrapper(configfile)

    for interface in ints:
        # Check if the IP for the host entry is correct
        try:
            ip_addr = omapi_wrapper.omapi_lookup(interface['mac'], 'host')
            if ip_addr != interface['ip']:
                failures.append(
		    "Host entry in DHCP does not match Foreman %s %s, expected %s received %s"
                    % (interface['name'], interface['mac'],
                        interface['ip'], ip_addr))
        except OmapiErrorNotFound:
            failures.append("No host entry in DHCP for %s %s"
                    % (interface['name'], interface['ip']))

        # Test for any dynamic leases associated with Foreman MAC addresses
        try:
            lease = omapi_wrapper.omapi_lookup(interface['mac'], 'lease')
            if getattr(lease, 'state') == 'active':
                failures.append("Active dynamic lease found for %s %s"
               	    % (interface['name'], interface['mac']))
        except OmapiErrorNotFound:
            pass

        # Check DNS is correct
        try:
            dns_ip = dns_lookup(interface['name'])
            if dns_ip != interface['ip']:
                failures.append("DNS address for \
                        %s does not match Foreman, expected %s got %s"
                     % (interface['name'], interface['ip'], dns_ip))
        except socket.gaierror:
            failures.append("No DNS entry found for %s" % interface['name'])

        # Check for each MAC there is a correct tftp entry
        # Munge the mac into the expected format for PXE
        if interface['type'] in ['bond', 'main']:
            if not os.path.exists(
                    pxe_root + '/01-' + interface['mac'].replace(':', '-')):
                failures.append("No PXE config found for %s %s"
                        % (interface['name'], interface['mac']))

    # Check back from DHCP for anything not in Foreman
    for host in get_host_list('/var/lib/dhcp/dhcpd.leases'):
        if not any(interface['name'] == host['name'] for interface in ints):
            failures.append("Entry exists in DHCP but not in Foreman %s "
                        % (host['name']))

    if failures:
        print "----------------------------------------------------------------"
        print "The following errors were found during automated Foreman checks:"
        print "----------------------------------------------------------------"
        for fail in failures:
            print fail

if __name__ == "__main__":
    main()
