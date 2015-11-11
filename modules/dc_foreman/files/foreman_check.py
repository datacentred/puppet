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

def dns_lookup(name):
    """
    Look up hostname in DNS
    """
    try:
        ip_addr = socket.gethostbyname(name)
        return ip_addr
    except socket.gaierror:
        raise

def get_proxy_subnets(proxy_name, proxy_dict, proxy_type):
    """
    Return a list of subnet_ids where proxy_name is the proxy
    """
    subnetid_list = [subnet['subnet_id'] \
            for subnet in proxy_dict \
            if subnet[proxy_type]['netloc'] == proxy_name]
    return subnetid_list

def get_host_list(lease_file):
    """
    Return a sensibly formatted list of hosts in DHCP
    Takes a list of file paths as an argument
    """
    host_list = []
    if os.path.isfile(lease_file) and os.access(lease_file, os.R_OK):
        host_parser = dc_dhcp_parser.DhcpHostsParser(lease_file)
        host_parser.parse()
        hosts = host_parser.get_hosts()
        for host in hosts:
            host_list.append({
                'name':host[0].lease_name,
                'ip':host[0].ip_addresses,
                'mac':host[0].mac_address})
    return host_list

def check_host_ips(subnet_proxies, alias, omapi_wrapper, ints):
    """
    Given an omapi wrapper and a set of interfaces
    Test that the IP entry is correct
    """
    failures = []
    subnet_ids = get_proxy_subnets(alias, subnet_proxies, 'dhcp_proxy')
    for interface in ints:
        if interface['subnet_id'] in subnet_ids:
        # Check if the IP for the host entry is correct
            try:
                ip_addr = omapi_wrapper.omapi_lookup(interface['mac'], 'host')
                if ip_addr != interface['ip']:
                    failures.append(
                        "Host entry in DHCP does not match Foreman %s %s, \
                                  expected %s received %s" % (
                                      interface['name'],
                                      interface['mac'],
                                      interface['ip'],
                                      ip_addr))
            except OmapiErrorNotFound:
                failures.append("No host entry in DHCP for %s %s" % (
                    interface['name'], interface['ip']))
    return failures

def check_dynamic_leases(subnet_proxies, alias, omapi_wrapper, ints):
    """
    Given an omapi wrapper and a set of interfaces
    Test if any dynamic leases exist
    """
    failures = []
    subnet_ids = get_proxy_subnets(alias, subnet_proxies, 'dhcp_proxy')
    for interface in ints:
        if interface['subnet_id'] in subnet_ids:
            try:
                lease = omapi_wrapper.omapi_lookup(interface['mac'], 'lease')
                if getattr(lease, 'state') == 'active':
                    failures.append("Active dynamic lease found for %s %s" % (
                        interface['name'], interface['mac']))
            except OmapiErrorNotFound:
                pass
    return failures

def check_dns(subnet_proxies, alias, ints):
    """
    Check DNS entries are correct
    """
    failures = []
    subnet_ids = get_proxy_subnets(alias, subnet_proxies, 'dhcp_proxy')
    for interface in ints:
        if interface['subnet_id'] in subnet_ids:
            try:
                dns_ip = dns_lookup(interface['name'])
                if dns_ip != interface['ip']:
                    failures.append("DNS address for \
                          %s does not match Foreman, expected %s got %s" % (
                              interface['name'], interface['ip'], dns_ip))
            except socket.gaierror:
                failures.append("No DNS entry found for %s" % interface['name'])
    return failures

def check_tftp(subnet_proxies, alias, ints, pxe_root):
    """
    Check TFTP configuration is correct
    """
    failures = []
    subnet_ids = get_proxy_subnets(alias, subnet_proxies, 'dhcp_proxy')
    for interface in ints:
        if interface['type'] in ['bond', 'main'] \
            and interface['subnet_id'] in subnet_ids:
            if not os.path.exists(
                    pxe_root + '/01-' + interface['mac'].replace(':', '-')):
                failures.append("No PXE config found for %s %s" % (
                    interface['name'], interface['mac']))
    return failures

def check_dhcp_leases(ints, lease_file):
    """
    Check for any hosts defined in DHCP but not in Foreman
    """
    failures = []
    for host in get_host_list(lease_file):
        if not host['name'] == 'icinga-check' and not \
            any(interface['name'] == host['name'] for interface in ints):
            failures.append("Entry exists in DHCP but not in Foreman %s " % (
                host['name']))
    return failures

############################################

def main():
    """
    Check proxy config against Foreman
    Expects config file in ini format eg.

    [foreman]
    foreman_api_user = some_user
    foreman_api_pw = some_password
    foreman_api_baseurl = https://foreman-server/api/v2/
    cert_path = a_cert
    cacert_path = a_cacert
    key_path = a_key
    proxy_alias = name_of_this_proxy_in_foreman

    [omapi]
    omapi_port = 7911
    omapi_key = some_key
    omapi_secret = some_secret
    dhcp_server = 127.0.0.1

    [tftp]
    pxe_root = /var/tftpboot/pxelinux.cfg

    [dhcp]
    lease_file = /var/lib/dhcp/dhcpd.leases

    """
    configfile = '/usr/local/etc/foreman_check.config'

    try:
        parser = ConfigParser.SafeConfigParser()
        parser.read(configfile)
    except ConfigParser.ParsingError, err:
        print 'Could not parse config file:', err
        sys.exit(1)
    pxe_root = parser.get('pxe', 'pxe_root')
    lease_file = parser.get('dhcp', 'lease_file')
    alias = parser.get('foreman', 'proxy_alias')

    # Create a Foreman object
    foreman_server = dc_foreman.Foreman(configfile)

    # Check we can reach the Foreman API
    foreman_server.check_api_endpoint()

    failures = []

    subnet_proxies = foreman_server.get_all_subnet_proxies()

    # Load a dictionary with all of the defined interfaces in Foreman
    ints = foreman_server.load_interfaces()

    # Create an OMAPI Wrapper object
    omapi_wrapper = dc_omapi.OmapiWrapper(configfile)

    # Check DHCP entries
    failures += check_host_ips(subnet_proxies, alias, omapi_wrapper, ints)

    failures += check_dynamic_leases(subnet_proxies, alias, omapi_wrapper, ints)

    failures += check_dns(subnet_proxies, alias, ints)

    failures += check_tftp(subnet_proxies, alias, ints, pxe_root)

    failures += check_dhcp_leases(ints, lease_file)

    if failures:
        print "----------------------------------------------------------------"
        print "The following errors were found during automated Foreman checks:"
        print "----------------------------------------------------------------"
        for fail in failures:
            print fail

if __name__ == "__main__":
    main()
