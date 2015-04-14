#!/usr/bin/env python
import netifaces
import sys
import subprocess
import os
import yaml

foreman_interfaces = []
ignored_interfaces = []

def configure():
    """
    Loads configuration data.  If required values aren't found
    execution continues with default values
    """
    global foreman_interfaces
    global ignored_interfaces

    try:
        config_file = open('/usr/local/etc/check_foreman_interfaces.yaml', 'r')
    except IOError:
        print 'Unable to open configuration file, check permissions'
        sys.exit(1)

    config = yaml.load(config_file.read())
    config_file.close()

    try:
        foreman_interfaces = config['managed_interfaces']
    except KeyError:
        print 'WARNING: unable to find managed_interfaces in configuration'

    try:
        ignored_interfaces = config['ignored_interfaces']
    except KeyError:
        print 'WARNING: unable to find ignored_interfaces in configuration'

# Find the LAN channel
def find_lan_channel():
    for c in range(1, 3):
        DEVNULL=open(os.devnull, 'r+b', 0)
        returncode = subprocess.call(['/usr/bin/ipmitool','lan','print',str(c)],stdin=DEVNULL, stdout=DEVNULL, stderr=DEVNULL)
        if returncode == 0:
            return c
    print "Could not find IPMI lan channel"
    return "Not Found"

# Get the IPMI MAC via ipmitool
def get_ipmi_mac(ipmi_lan_chan):
    command = '/usr/bin/ipmitool lan print %s | grep \'MAC Address\' | awk \'{print $4}\'' % ipmi_lan_chan
    mac = subprocess.check_output(command, shell=True).strip()
    return mac

# Get the IPMI IP via ipmitool
def get_ipmi_ip(ipmi_lan_chan):
    command = '/usr/bin/ipmitool lan print %s | grep \'IP Address  \' | awk \'{print $4}\'' % ipmi_lan_chan
    ip = subprocess.check_output(command, shell=True).strip()
    return ip

# Check an interface against the configured system interfaces
def check_foreman_int(mac, ip, identifier):
    addrs = netifaces.ifaddresses(identifier)
    if netifaces.AF_INET in addrs:
            if addrs[netifaces.AF_LINK][0]['addr'] == mac and addrs[netifaces.AF_INET][0]['addr'] == ip:
                return True
            else:
                return False
    else:
        return False

# Check an interface against Foreman
def check_system_int(ip,mac,identifier):
    foreman_int = next((i for i in foreman_interfaces if i['identifier'] == identifier), None)
    if foreman_int != None:
        if ip == foreman_int['ip'] and mac == foreman_int['mac']:
            return True
        else:
            return False
    else:
        return False
	
def main():		

    configure()

    local_interfaces = [ x for x in netifaces.interfaces() if x not in ignored_interfaces ]

    # The foreman_interfaces check can mis-identify bonded interfaces
    # so remove any interfaces which match a defined bond
    bond = next((i for i in foreman_interfaces if i['type'] == 'Bond'), False)
    if bond:
        bonded_ifs = bond['attached_devices'].split(',')
        foreman_interfaces[:] = [x for x in foreman_interfaces if x.get('identifier') not in bonded_ifs]

    # Check the interfaces in Foreman against the configured system interfaces
    for interface in foreman_interfaces:
        if interface['type'] != 'BMC':
            if not check_foreman_int(interface['mac'], interface['ip'], interface['identifier']):
                print "WARNING: Foreman interface %s %s %s does not match the system" % (interface['mac'],interface['ip'],interface['identifier'])
                sys.exit(1)

    # Check the configured interfaces on the system back against Foreman
    for i in local_interfaces:
        addrs = netifaces.ifaddresses(i)
        if netifaces.AF_INET in addrs:
            if not check_system_int(addrs[netifaces.AF_INET][0]['addr'],addrs[netifaces.AF_LINK][0]['addr'],i):
                print "WARNING: Configured system interface does not match Foreman %s %s %s" % (addrs[netifaces.AF_INET][0]['addr'],addrs[netifaces.AF_LINK][0]['addr'],i)
                sys.exit(1)

    # Check the BMC interface
    ipmi_lan_chan = find_lan_channel()
    if ipmi_lan_chan != "Not Found":
        bmc_mac = get_ipmi_mac(ipmi_lan_chan)
        bmc_ip = get_ipmi_ip(ipmi_lan_chan)
        bmc_int = next((interface for interface in foreman_interfaces if interface['type'] == 'BMC'), None)
        if bmc_int != None:
            if not bmc_int['ip'] == bmc_ip and not bmc_int['mac'] == bmc_mac:
                print "WARNING: BMC configuration does not match Foreman"
                sys.exit(1)

    print "OK: All interfaces matched to Foreman"

if __name__ == "__main__":
    main()

# vi: ts=4 et:
