#!/usr/bin/env python
"""
Script to partition up hard drives into N chunks of M (GiB) size.
Side steps puppet's lack of ordering which make idempotency
pretty much impossible!
"""

import sys
import re
import subprocess

# Syntax checking
try:
    dev  = sys.argv[1]
    num  = int(sys.argv[2])
    size = int(sys.argv[3])
except:
    print 'ERROR: Syntax invalid'
    sys.exit(1)

# Try read out the partition table data
try:
    table = subprocess.check_output(['parted', '-s', dev, 'print']).split('\n')
except:
    pass

# If we got some table data search for a GPT partition table
try:
    table
except:
    pass
else:
    print 'INFO: Searching for GPT partiton table'
    for line in table:
        if re.search('Partition Table: gpt', line):
            found_table = True
            break

# If there is no GPT partition table defined create one
try:
    found_table
except:
    print "INFO: Creating partition table"
    try:
        subprocess.check_call(['parted', '-s', dev, 'mklabel', 'gpt'])
    except:
        print 'ERROR: Unable to create partition table'
        sys.exit(1)

# Next create the partitions
for index in range(0, num):

    partition = index + 1
    start = index * size
    end = (index + 1) * size

    # Check to see if the partition exists
    try:
        table
    except:
        pass
    else:
        for line in table:
            if re.match('^ {0}.*osd{0}$'.format(partition), line):
                found_partition = True
                break

    # If not create it
    try:
        found_partition
    except:
        print 'INFO: Creating partition {0}'.format(partition)
        try:
            subprocess.check_call([
                'parted', '-s', '-a', 'optimal', dev, 'mkpart',
                'osd{0}'.format(partition),
                '{0}GiB'.format(start),
                '{0}GiB'.format(end)
            ])
        except:
            print 'ERROR: Unable to create partition {0}'.format(partition)
            sys.exit(1)

