#!/usr/bin/env bash

# Quick script to get a dump (AXFR) of RRs that we'd potentially want to restore
# Takes two arguments - target NS and the domain
# Assumption is you're doing this on a network segment for which BIND will let
# you do AXFRs, of course...
# nick.jones@datacentred.co.uk

NS=$1
DOMAIN=$2
TS=$(date "+%y-%m-%d-%H%M%S")

dig @$NS $DOMAIN AXFR | grep -v -E ';|SOA|NS|AAAA' | awk 'NF > 0' > $DOMAIN.$TS.axfr

