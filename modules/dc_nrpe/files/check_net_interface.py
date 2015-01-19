#!/usr/bin/env python
import netifaces,fnmatch,re,subprocess,sys
correct_mtu='9000'

def get_mtu(interface):
    output = subprocess.Popen(['ifconfig', interface], stdout=subprocess.PIPE).communicate()[0]
    mtu = re.findall('MTU:([0-9]*) ', output)[0]
    return (mtu)

def main():
    for interface in fnmatch.filter(netifaces.interfaces(), 'p?p?'):
        mtu_int=get_mtu(interface)
        if mtu_int != $correct_mtu:
            print "CRITICAL: Jumbo frames are not configured correctly on interface %s" % interface
            sys.exit(2)
        else:
            print "OK: Jumbo frames configured correctly on all interfaces"
            sys.exit(0)

if __name__ == '__main__':
    main()

