#!/usr/bin/env python
"""
Perform Disk Statistics Checks

Monitors for long write times which is indicative that the device
can't keep up, due to high load or drive wear
"""

import os
import sys
import re
import yaml
import pickle

NAGIOS_OK = 0
NAGIOS_WARNING = 1
NAGIOS_CRITICAL = 2
NAGIOS_UNKNOWN = 3

FIELD_WR = 0
FIELD_WR_MS = 1

def configure():
    """Open and parse the YAML configuration file"""

    try:
        config_file = open('/usr/local/etc/check_journal_disk.yaml', 'r')
    except IOError:
        print 'Unable to open configuration file, check permissions'
        sys.exit(1)

    config = yaml.load(config_file.read())
    config_file.close()

    return config

def valid_block_device(device):
    """Is this device backed by a physical bit of hardware"""

    path = '/sys/block/{}/device'.format(device)
    return os.access(path, os.F_OK)

def detect_block_devices(config):
    """Find block devices that are backed by a physical device"""

    device = config['journal_disk']
    if valid_block_device(device):
        return device
    else:
        print "Could not access journal device!"
        sys.exit(1)

def get_write_stats(devices):
    """Get the current write statistics for devices we care about"""
    try:
        with open('/proc/diskstats', 'r') as disk_stats_file:
            disk_stats_output = disk_stats_file.read().rstrip().split('\n')
    except IOError:
        print "Could not open /proc/diskstats!"
        sys.exit(1)

    disk_stats = {}
    for stats in disk_stats_output:
        fields = re.findall(r'\w+', stats)
        if fields[2] not in devices:
            continue
        disk_stats[fields[2]] = [fields[7], fields[10]]
    return disk_stats

def set_status(context, status):
    """Sets the nagios status code"""
    context['status'] = max(context['status'], status)

def add_output(context, message):
    """Adds a line of output"""
    context['output'].append(message)

def check_for_histstats(context, histstatsfile):
    """Check if we have historical stats"""
    if os.path.isfile(histstatsfile):
        try:
            with open(histstatsfile, 'rb') as hist_data_file:
                hist_data_output = pickle.load(hist_data_file)
                return hist_data_output
        except IOError:
            print "Could not open historical data file!"
            sys.exit(1)
    else:
        set_status(context, NAGIOS_UNKNOWN)
        add_output(context, 'UNKNOWN: {}: no historical data')
        return False

def write_histstats(histstatsfile, stats):
    """Write the historical stats data to a file as a binary structure"""
    try:
        with open(histstatsfile, 'wb') as hist_data_file:
            pickle.dump(stats, hist_data_file)
            hist_data_file.close()
    except IOError:
        print "Could not write stats file !"
        sys.exit(1)

def check_write_times(context, config, stats, hist_stats):
    """Check the average write times at the current time"""
    for device in stats:
        write_ms = int(stats[device][1]) - int(hist_stats[device][1])
        write_count = int(stats[device][0]) - int(hist_stats[device][0])
        if write_count > 0:
            # Calculate average write time and compare to threshold
            average_write_ms = float(write_ms)/float(write_count)
            if average_write_ms >= \
                    float(config['journal_disk_latency']['crit']):
                set_status(context, NAGIOS_CRITICAL)
                add_output(context,
                        'CRITICAL: {}: avg write time {} >= {}'.format(
                    device,
                    average_write_ms,
                    config['journal_disk_latency']['crit'],
                ))
            elif average_write_ms >= \
                    float(config['journal_disk_latency']['warn']):
                set_status(context, NAGIOS_WARNING)
                add_output(context,
                        'WARNING: {}: avg write time {} >= {}'.format(
                    device,
                    average_write_ms,
                    config['journal_disk_latency']['warn'],
                ))

def main():
    """Main entry point"""
    config = configure()
    context = {
        'status': NAGIOS_OK,
        'output': [],
    }
    devices = detect_block_devices(config)
    stats = get_write_stats(devices)
    hist_stats = check_for_histstats(context, config['hist_stats_file'])
    if hist_stats:
        check_write_times(context, config, stats, hist_stats)
    write_histstats(config['hist_stats_file'], stats)

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
