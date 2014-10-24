#!/usr/bin/env python

"""
DataCentred Ceph OSD location hook
Location information is passed in from the ENC via a local external fact
"""

import sys
import getopt
import subprocess

def main(argv):
	"""A comment"""
	# Ceph provided options
	opt = getopt.getopt(argv, '', ['cluster=', 'id=', 'type='])
	# Location from facter/ENC
	locstr = subprocess.check_output(['facter', 'crush_location']).rstrip()
	locarr = locstr.split(':')
	# Host from the system
	host = subprocess.check_output(['hostname', '-s'])

	# Build the names in a heirarchical manner as crush references child
	# entities by name and not uuid
	datacenter = locarr[0]
	room = "{0}-{1}".format(locarr[0], locarr[1])
	rack = "{0}-{1}-{2}".format(locarr[0], locarr[1], locarr[2])
	chassis = "{0}-{1}-{2}-{3}".format(locarr[0], locarr[1], locarr[2], locarr[3])

	# Dump out the crush location
	print "root=default datacenter={0} room={1} rack={2} chassis={3} host={4}".\
		format(datacenter, room, rack, chassis, host)

if __name__ == '__main__':
	main(sys.argv[1:])

# vi: ts=4 noet:
