#!/usr/bin/env python

import yaml
import sys
import subprocess

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3
logstash_pp_warn_threshold = 20
logstash_pp_crit_threshold = 50

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

if entries[1][(entries[0].index('Pending Payloads'))] > logstash_pp_crit_threshold:
  print "CRITICAL: There are more than %d messages to logstash pending" % logstash_pp_crit_threshold
  sys.exit(CRITICAL)
elif entries[1][(entries[0].index('Pending Payloads'))] > logstash_pp_warn_threshold:
  print "WARNING: There are more than %d messages to logstash pending" % logstash_pp_warn_threshold
  sys.exit(WARNING)
elif entries[1][(entries[0].index('Pending Payloads'))] <= logstash_pp_warn_threshold:
  print "OK: Low number of pending payloads"
  sys.exit(OK)
else:
  print "UNKNOWN: Unknown error"
  sys.exit(UNKNOWN)
