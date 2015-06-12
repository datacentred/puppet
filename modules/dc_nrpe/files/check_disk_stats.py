#!/usr/bin/env python
"""
Perform Disk Statistics Checks

Monitors for deep IO wait queues which is indicative that the device
can't keep up, due to high load or drive wear
"""

import os
import sys
import re
import yaml

NAGIOS_OK = 0
NAGIOS_WARNING = 1
NAGIOS_CRITICAL = 2
NAGIOS_UNKNOWN = 3

FIELD_RD = 0
FIELD_RD_MRG = 1
FIELD_RD_SEC = 2
FIELD_RD_MS = 3
FIELD_WR = 4
FIELD_WR_MRG = 5
FIELD_WR_SEC = 6
FIELD_WR_MS = 7
FIELD_IO = 8
FIELD_IO_MS = 9
FIELD_IO_MS_WT = 10

def configure():
    """Open and parse the YAML configuration file"""

    try:
        config_file = open('/usr/local/etc/check_disk_stats.yaml', 'r')
    except IOError:
        print 'Unable to open configuration file, check permissions'
        sys.exit(1)

    config = yaml.load(config_file.read())
    config_file.close()

    return config

def valid_block_device(device):
    """Is this device backed by a pysical bit of hardware"""

    path = '/sys/block/{}/device'.format(device)
    return os.access(path, os.F_OK)

def detect_block_devices():
    """Find block devices that are backed by a physical device"""

    all_devices = os.listdir('/sys/block')
    return [device for device in all_devices if valid_block_device(device)]

def get_disk_stats(devices):
    """Get the current disk statistics for devices we care about"""

    with open('/proc/diskstats', 'r') as disk_stats_file:
        disk_stats_output = disk_stats_file.read().rstrip().split('\n')

    disk_stats = {}
    for stats in disk_stats_output:
        fields = re.findall(r'\w+', stats)
        if fields[2] not in devices:
            continue
        disk_stats[fields[2]] = [int(x) for x in fields[3:]]
    return disk_stats

def set_status(context, status):
    """Sets the nagios status code"""
    context['status'] = max(context['status'], status)

def add_output(context, message):
    """Adds a line of output"""
    context['output'].append(message)

def check_queue_depth(context, config, stats):
    """Check the queue depth at the current time"""
    for device in stats:
        if stats[device][FIELD_IO] >= config['queue_depth']['crit']:
            set_status(context, NAGIOS_CRITICAL)
            add_output(context, 'CRITICAL: {}: io queue {} >= {}'.format(
                device,
                stats[device][FIELD_IO],
                config['queue_depth']['crit']
                ))
        elif stats[device][FIELD_IO] >= config['queue_depth']['warn']:
            set_status(context, NAGIOS_CRITICAL)
            add_output(context, 'WARNING: {}: io queue {} >= {}'.format(
                device,
                stats[device][FIELD_IO],
                config['queue_depth']['warn'],
                ))

def main():
    """Main entry point"""
    config = configure()
    devices = detect_block_devices()
    stats = get_disk_stats(devices)

    context = {
        'status': NAGIOS_OK,
        'output': [],
    }

    check_queue_depth(context, config, stats)

    status_strings = [
        'OK: everything is awesome',
        'WARNING: something is wrong',
        'CRITICAL: abandon ship!',
        'UNKNOWN: sadpanda',
    ]
    context['output'].insert(0, status_strings[context['status']])

    print '\n'.join(context['output'])
    sys.exit(context['status'])

if __name__ == '__main__':
    main()

# vi: ts=4 et:
