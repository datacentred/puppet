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


def write_telegraf_line(data, virt_machine):
    """ Takes a dict and formats and prints the output in telegraf format """
    line = ','.join("{}={}i".format(key, val) for key, val in data.items())
    print 'libvirt,instance={} {}'.format(virt_machine.name(), line)


def get_network_stats(virt_machine):
    """ Collect network statistics """
    tree = ElementTree.fromstring(virt_machine.XMLDesc())
    iface = tree.find('devices/interface/target').get('dev')
    labels = [
        'read_bytes', 'read_packets', 'read_errors', 'read_drops',
        'write_bytes', 'write_packets', 'write_errors', 'write_drops'
    ]
    return dict(zip(labels, virt_machine.interfaceStats(iface)))


def get_stats(conn):
    """ Grabs list of domains and iterates over each one to gather stats """
    domains = conn.listDomainsID()
    for dom in domains:
        virt_machine = conn.lookupByID(dom)
        write_telegraf_line(get_network_stats(virt_machine), virt_machine)
    conn.close()
    exit(0)

if __name__ == "__main__":
    setup_connection()
# vi:ts=4 et:
