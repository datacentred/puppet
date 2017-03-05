#!/usr/bin/env python
# pylint: disable=F0401
"""
Gathers libvirt statistics for running instances and outputs
in a format that can be used with telegraf's exec plugin
"""
from xml.etree import ElementTree
import libvirt

LIBVIRT_CONN = 'qemu:///system'


def setup_connection():
    """ Initiates a connection and if successful starts stats gathering """
    try:
        conn = libvirt.openReadOnly(LIBVIRT_CONN)
    except OSError:
        print('Failed to open libvirt connection:', LIBVIRT_CONN)
    else:
        get_stats(conn)


def write_telegraf_line(data, virtm, series_type, device=None):
    """ Takes a dict and formats and prints the output in telegraf format """
    line = ','.join("{}={}".format(key, val) for key, val in data.items())
    if series_type == 'block':
        print 'libvirt_{},instance={},device={} {}'.format(series_type, virtm.name(), device, line)
    else:
        print 'libvirt_{},instance={} {}'.format(series_type, virtm.name(), line)


def enumerate_block_devices(virtm):
    """ Enumerates the block devices present on an instance and returns an array """
    tree = ElementTree.fromstring(virtm.XMLDesc(0))
    #The list of block device names.
    devices = []
    #Iterate through all disk target elements of the domain.
    for target in tree.findall("devices/disk/target"):
        #Get the device name.
        dev = target.get("dev")
        #Check if we have already found the device name for this domain.
        if not dev in devices:
            devices.append(dev)
    #Completed device name list.
    return devices


def get_block_stats(virtm, device):
    """ Collect block device statistics """
    labels = ['read_requests', 'read_bytes', 'write_requests', 'write_bytes', 'errors']
    return dict(zip(labels, virtm.blockStats(device)))


def get_network_stats(virtm):
    """ Collect network statistics """
    tree = ElementTree.fromstring(virtm.XMLDesc())
    iface = tree.find('devices/interface/target').get('dev')
    labels = [
        'read_bytes', 'read_packets', 'read_errors', 'read_drops',
        'write_bytes', 'write_packets', 'write_errors', 'write_drops'
    ]
    return dict(zip(labels, virtm.interfaceStats(iface)))


def get_stats(conn):
    """ Grabs list of domains and iterates over each one to gather stats """
    domains = conn.listDomainsID()
    for dom in domains:
        virtm = conn.lookupByID(dom)
        write_telegraf_line(get_network_stats(virtm), virtm, 'network')
        for device in enumerate_block_devices(virtm):
            write_telegraf_line(get_block_stats(virtm, device), virtm, 'block', device)
    conn.close()
    exit(0)

if __name__ == "__main__":
    setup_connection()
# vi:ts=4 et:
