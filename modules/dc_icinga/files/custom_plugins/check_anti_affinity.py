#!/usr/bin/env python
"""
Check for incorrect anti-affinity rules
"""
# pylint: disable=import-error

import os
import sys
import argparse
import subprocess
import json

NAGIOS_OK = 0
NAGIOS_WARNING = 1
NAGIOS_CRITICAL = 2
NAGIOS_UNKNOWN = 3

def main():
    """
    Main script body
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', '--username', required=True)
    parser.add_argument('-p', '--password', required=True)
    parser.add_argument('-t', '--tenant_name', required=True)
    parser.add_argument('-a', '--auth_url', required=True)
    args = parser.parse_args()

    os.environ['OS_AUTH_URL'] = args.auth_url
    os.environ['OS_USERNAME'] = args.username
    os.environ['OS_PASSWORD'] = args.password
    os.environ['OS_TENANT_NAME'] = args.tenant_name

    check = subprocess.Popen('/usr/lib/nagios/plugins/antiaffinitycheck.py --all --json',
                             shell=True,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
    (stdoutdata, stderrdata) = check.communicate()

    if stderrdata:
        print "UNKNOWN: Error running check %s" % stderrdata
        sys.exit(NAGIOS_UNKNOWN)
    elif stdoutdata:
        json_data = json.loads(stdoutdata)
        group_ids = []
        for instance in json_data:
            if instance['server_group_id'] not in group_ids:
                group_ids.append(instance['server_group_id'])
        group_ids_string = ','.join([str(x) for x in group_ids])
        print "CRITICAL: Anti-affinity violations detected on server groups %s" % group_ids_string
        sys.exit(NAGIOS_CRITICAL)
    else:
        print "OK: No anti-affinity violations detected"
        sys.exit(NAGIOS_OK)

if __name__ == "__main__":
    main()
