#!/usr/bin/env python

import yaml
import sys
import subprocess

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3

subprocess.call(["lc-admin status > /tmp/lc-admin-output.txt"], shell=True)
lines = open("/tmp/lc-admin-output.txt", 'r').readlines()
del lines[0:4]
file = open("/tmp/lc-admin-yaml.yaml", 'w')
for line in lines:
    file.write(line)
file.close()

entries = [[],[]]
stream = open("/tmp/lc-admin-yaml.yaml", 'r')
for key, value in yaml.load(stream)['Publisher'].iteritems():
     entries[0].append(key)
     entries[1].append(value)

if entries[1][(entries[0].index('Status'))] == 'Disconnected':
  print "CRITICAL: Publisher disconnected from logstash"
  sys.exit(CRITICAL)
elif entries[1][(entries[0].index('Timeouts'))] > 0:
  print "WARNING: There are timeouts sending to logstash"
  sys.exit(WARNING)
elif (entries[1][(entries[0].index('Timeouts'))] == 0) and (entries[1][(entries[0].index('Status'))] == 'Connected'):
  print "OK: Publisher connected to logstash, no timeouts"
  sys.exit(OK)
else:
  print "UNKNOWN: I didn't forsee this problem!"
  sys.exit(UNKNOWN)
