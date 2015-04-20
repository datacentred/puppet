#!/usr/bin/env python
"""
Check network interfaces
between Foreman and system
"""
import netifaces
import sys
import subprocess
import os
import yaml
import re

FOREMAN_INTERFACES = []
IGNORED_INTERFACES = []

def configure():
    """
    Loads configuration data.  If required values aren't found
    execution continues with default values
    """
    global FOREMAN_INTERFACES
    global IGNORED_INTERFACES

    try:
        config_file = open('/usr/local/etc/check_foreman_interfaces.yaml', 'r')
    except IOError:
        print 'Unable to open configuration file, check permissions'
        sys.exit(1)

    config = yaml.load(config_file.read())
    config_file.close()

    try:
        FOREMAN_INTERFACES = config['managed_interfaces']
    except KeyError:
        print 'WARNING: unable to find managed_interfaces in configuration'

    try:
        IGNORED_INTERFACES = config['ignored_interfaces']
    except KeyError:
        print 'WARNING: unable to find ignored_interfaces in configuration'

def find_lan_channel():
    """
    Find the IPMI LAN channel
    """
    for chan in range(1, 3):
        devnull = open(os.devnull, 'r+b', 0)
        returncode = subprocess.call(
            ['/usr/bin/ipmitool', 'lan', 'print', str(chan)],
            stdin=devnull, stdout=devnull, stderr=devnull)
        if returncode == 0:
            return chan
    return False

def get_ipmi_mac(ipmi_lan_chan):
    """
    Get the IPMI MAC via ipmitool
    """
    command = '/usr/bin/ipmitool lan print %s | \
        grep \'MAC Address\' | awk \'{print $4}\'' % ipmi_lan_chan
    mac = subprocess.check_output(command, shell=True).strip()
    return mac

def get_ipmi_ip(ipmi_lan_chan):
    """
    Get the IPMI IP via ipmitool
    """
    command = '/usr/bin/ipmitool lan print %s | \
            grep \'IP Address  \' | awk \'{print $4}\'' % ipmi_lan_chan
    ipmi_ip = subprocess.check_output(command, shell=True).strip()
    return ipmi_ip

def check_foreman_int(mac, ip_address, identifier):
    """
    Check an interface against the configured system interfaces
    """
    addrs = netifaces.ifaddresses(identifier)
    if netifaces.AF_INET in addrs:
        if (addrs[netifaces.AF_LINK][0]['addr'] == mac
                and addrs[netifaces.AF_INET][0]['addr'] == ip_address):
            return True
        else:
            return False
    else:
        return False

def check_system_int(ip_address, mac, identifier):
    """
    Check an interface against Foreman
    """
    foreman_int = next(
            (i for i in FOREMAN_INTERFACES
                if i['identifier'] == identifier), None)
    if foreman_int != None:
        if ip_address == foreman_int['ip'] and mac == foreman_int['mac']:
            return True
        else:
            return False
    else:
        return False

def find_identifier(mac):
    """
    Find an interface on the system given its mac address
    """
    real_interfaces = [
            x for x in netifaces.interfaces() if not x.startswith('bond')
    ]
    for interface in real_interfaces:
        addrs = netifaces.ifaddresses(interface)
        try:
            if addrs[netifaces.AF_LINK][0]['addr'] == mac:
                return interface
        except LookupError:
            continue
    return False

def check_bmc_interface():
    """
    Check the BMC interface against Foreman
    """
    ipmi_lan_chan = find_lan_channel()
    if ipmi_lan_chan:
        bmc_mac = get_ipmi_mac(ipmi_lan_chan)
        bmc_ip = get_ipmi_ip(ipmi_lan_chan)
        bmc_int = next(
                (interface for interface in FOREMAN_INTERFACES
                      if interface['type'] == 'BMC'), None)
        if bmc_int:
            if not bmc_int['ip'] == bmc_ip and not bmc_int['mac'] == bmc_mac:
                return False
    else:
        return True
    return True

def check_for_static(interface):
    """
    Check if an interface is defined as static
    """
    local_conf = open('/etc/network/interfaces', 'r')
    regex = "^iface %s" % interface
    for line in local_conf:
        if re.search(regex, line):
            if line.rsplit(None, 1)[-1] != 'static':
                return True
            else:
                return False
        else:
            return False

def main():
    """
    Check all interfaces line up
    between Foreman and configured system interfaces
    """

    configure()

    local_interfaces = [
            x for x in netifaces.interfaces()
            if x not in IGNORED_INTERFACES
    ]

    # Foreman can be missing idents so look them up and fill them in first
    for i, interface in enumerate(FOREMAN_INTERFACES):
        if interface['identifier'] == None and interface['type'] != 'BMC':
            ident = find_identifier(interface['mac'])
            if ident:
                FOREMAN_INTERFACES[i]['identifier'] = ident
            else:
                print "WARNING: MAC %s in Foreman does not exist on system" \
                            % interface['mac']
                sys.exit(1)

    # The foreman_interfaces check can mis-identify bonded interfaces
    # so remove any interfaces which match a defined bond
    bond = next((i for i in FOREMAN_INTERFACES if i['type'] == 'Bond'), False)
    if bond:
        bonded_ifs = bond['attached_devices'].split(',')
        FOREMAN_INTERFACES[:] = [
                x for x in FOREMAN_INTERFACES
                if x.get('identifier') not in bonded_ifs
        ]

    # Check the interfaces in Foreman against the configured system interfaces
    for interface in FOREMAN_INTERFACES:
        if interface['type'] != 'BMC':
            if not check_foreman_int(
                interface['mac'], interface['ip'], interface['identifier']):
                print "WARNING: Foreman interface %s %s %s \
                            does not match the system" \
                        % (interface['mac'], interface['ip'],
                                interface['identifier'])
                sys.exit(1)

    # Check the configured interfaces on the system back against Foreman
    for i in local_interfaces:
        addrs = netifaces.ifaddresses(i)
        if netifaces.AF_INET in addrs:
            if not check_system_int(
                    addrs[netifaces.AF_INET][0]['addr'],
                    addrs[netifaces.AF_LINK][0]['addr'], i) \
                            and not check_for_static(i):
                print "WARNING: Configured system interface \
                        does not match Foreman %s %s %s" \
                    % (addrs[netifaces.AF_INET][0]['addr'],
                        addrs[netifaces.AF_LINK][0]['addr'], i)
                sys.exit(1)

    # Check the BMC interface
    bmc_int = check_bmc_interface()
    if not bmc_int:
        print "WARNING: BMC interface does not match Foreman"
        sys.exit(1)

    print "OK: All interfaces matched to Foreman"

if __name__ == "__main__":
    main()

# vi: ts=4 et:
