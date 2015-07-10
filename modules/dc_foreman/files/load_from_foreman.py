#!/usr/bin/env python
"""
Script to do first time load of network services data from Foreman
Requires the dc_foreman and dc_omapi python modules
"""
import sys
import socket
import os
import ConfigParser
import dc_foreman
import dc_omapi
import dc_dhcp_parser
import dns.query
import dns.tsigkeyring
import dns.update

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

def add_dns_entry(dns_entry, keyring):
    """
    Add a DNS entry to a local DNS server
    """
    update = dns.update.Update(dns_entry['zone'], keyring=keyring)
    update.add(dns_entry['name'],
            dns_entry['ttl'], dns_entry['type'], dns_entry['rdata'])
    try:
        dns.query.tcp(update, '127.0.0.1')
    except dns.tsig.PeerBadKey:
        print 'ERROR: Bad key'
        exit()
    except dns.tsig.PeerBadSignature:
        print 'ERROR: Bad key signature'
        exit()

def gen_rev(ip_address):
    """
    Return the reverse-map domain name of an IP address
    """
    rev_domain = '.'.join(list(
        reversed(ip_address.split('.')[:-1]))) + ".in-addr.arpa"
    return rev_domain

############################################

def main():
    """
    Load proxy config from Foreman
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

    [dhcp]
    lease_file = /var/lib/dhcp/dhcpd.leases

    [dns]
    key = /etc/bind/rndc.key

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
    dns_key = parser.get('dns', 'key')

    # Create a Foreman object
    foreman_server = dc_foreman.Foreman(configfile)

    # Check we can reach the Foreman API
    foreman_server.check_api_endpoint()

    # Load a dictionary with all of the defined interfaces in Foreman
    ints = foreman_server.load_interfaces()

    # Create an OMAPI Wrapper object
    omapi_wrapper = dc_omapi.OmapiWrapper(configfile)

    # Get a list of the existing DHCP entries
    dhcp_hosts = get_host_list(lease_file)

    # Build a DNS keyring from the key file
    lines = [line.strip() for line in open(dns_key)]
    key_name = lines[0].translate(None, '";{').split(' ')[1]
    key_secret = lines[2].translate(None, '";').split(' ')[1]
    dns_keyring = dns.tsigkeyring.from_text({key_name : key_secret})

    for interface in ints:
        # If DHCP entry doesn't exist then create it
        if not any(interface['name'] == host['name'] for host in dhcp_hosts):
            omapi_wrapper.add_host(interface['ip'],
                    interface['mac'], interface['name'])
        else:
            print "%s already exists" % interface['name']
        # If DNS entry doesn't exist then create it
        dns_entries = []
        dns_name, domain_name = interface['name'].split('.', 1)
        dns_entries.append({
                    'name':dns_name,
                    'rdata':interface['ip'],
                    'ttl':'86400',
                    'zone':domain_name,
                    'type':'A'})
        dns_entries.append({
                    'name':interface['ip'].split('.')[3],
                    'rdata':interface['name'],
                    'ttl':'86400',
                    'zone':gen_rev(interface['ip']),
                    'type':'PTR'})
        for entry in dns_entries:
            add_dns_entry(entry, dns_keyring)

        # If TFTP object doesn't exist then create it
        if interface['type'] in ['bond', 'main']:
            pxe_path = pxe_root + '/01-' + interface['mac'].replace(':', '-')
            if not os.path.exists(pxe_path):
                host_info = foreman_server.get_host_info(interface['host_id'])
                with open(pxe_path, 'w') as pxe_file:
                    pxe_file.writelines([
                        'DEFAULT menu\n', 'PROMPT 0\n', 'MENU TITLE PXE Menu\n',
                        'TIMEOUT 20\n', 'ONTIMEOUT local\n', '\n',
                        'LABEL local\n', '     MENU LABEL (local)\n',
                        '     MENU DEFAULT\n'])
                    if host_info['architecture_name'] == 'x86_64':
                        pxe_file.writelines(
                            ['     com32 chain.c32\n', '     append hd0\n'])
                    else:
                        pxe_file.writelines(['     LOCALBOOT 0\n'])
                pxe_file.close()

if __name__ == "__main__":
    main()
