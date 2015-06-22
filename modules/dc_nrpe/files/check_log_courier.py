#!/usr/bin/env python
"""
Checks log courier is connected and keeping up
"""

import yaml
import sys
import subprocess

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3
PENDING_WARN = 20
PENDING_CRIT = 50

def main():
    """
    Main subroutine
    Runs lc-admin, cleans output, parses and runs some rudimentary checks
    """
    try:
        output = subprocess.check_output(['lc-admin', 'status'])
    except subprocess.CalledProcessError:
        print 'UNKNOWN: lc-admin returned non-zero status'
        sys.exit(UNKNOWN)

    # Clean up the ouput into raw json
    output = '\n'.join(output.split('\n')[5:])
    output = yaml.load(output)

    # Check things are doing something
    try:
        if output['Publisher']['Status'] != 'Connected':
            print 'CRITICAL: not connected to logstash'
            sys.exit(CRITICAL)

        if output['Publisher']['Pending Payloads'] >= PENDING_CRIT:
            print 'CRITICAL: pending payloads >= {}'.format(PENDING_CRIT)
            sys.exit(CRITICAL)

        if output['Publisher']['Pending Payloads'] >= PENDING_WARN:
            print 'WARNING: pending payloads >= {}'.format(PENDING_WARN)
            sys.exit(WARNING)

        print 'OK: everything is awesome'
        sys.exit(OK)

    except KeyError:
        print 'UNKNOWN: malformed output'
        sys.exit(UNKNOWN)

if __name__ == '__main__':
    main()

# vi: ts=4 et:
