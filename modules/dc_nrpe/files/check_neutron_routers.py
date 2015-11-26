#!/usr/bin/env python
"""
Check for duplicated routers
"""
from neutronclient.v2_0 import client
import sys
import argparse

def main():
    """
    Check for duplicate router
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', '--username', required=True)
    parser.add_argument('-p', '--password', required=True)
    parser.add_argument('-t', '--tenant_name', required=True)
    parser.add_argument('-a', '--auth_url', required=True)
    args = parser.parse_args()

    neutron = client.Client(username=args.username, password=args.password,
                            tenant_name=args.tenant_name,
                            auth_url=args.auth_url)
    neutron.format = 'json'

    dupes = []
    i = 0
    for router in neutron.list_routers()['routers']:
        l3_agents = neutron.list_l3_agent_hosting_routers(router['id'])
        if len(l3_agents['agents']) > 1:
            i += 1
            dupes.append("%s has %s l3 agents" %
                         (router['id'], len(l3_agents['agents'])))

    if i == 0:
        print "No duplicate l3 agents found"
        sys.exit(0)
    else:
        print dupes
        sys.exit(1)

if __name__ == "__main__":
    main()
