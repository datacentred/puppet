#!/usr/bin/env python

"""
DataCentred Ceph OSD location hook
"""

import ConfigParser

def main():
    """
    Reads puppet generated configuration data and creates a physical location
    for ceph OSD placement in the crush map.
    """

    config = ConfigParser.ConfigParser()
    config.read('/usr/local/etc/location_hook.ini')

    root = config.get('main', 'root')
    datacenter = config.get('main', 'datacenter')
    room = config.get('main', 'room')
    rack = config.get('main', 'rack')
    chassis = config.get('main', 'chassis')
    host = config.get('main', 'host')

    if root != 'default':
        prefix = root + '-'
    else:
        prefix = ''

    print "root={} datacenter={} room={} rack={} chassis={} host={}".format(
        root,
        prefix + datacenter,
        prefix + datacenter + '-' + room,
        prefix + datacenter + '-' + room + '-' + rack,
        prefix + datacenter + '-' + room + '-' + rack + '-' + chassis,
        host,
    )

if __name__ == '__main__':
    main()

# vi: ts=4 et:
