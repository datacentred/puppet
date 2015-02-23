#!/bin/bash
# Set the SEL time correctly
# This 'should' be set by the BIOS on boot but doesn't seem to always be true
DATE=`date +"%m/%d/%Y %H:%M:%S"`
IPMITOOL=`which ipmitool`
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then
        echo "This script is already running with PID `pidof -x $(basename $0) -o %PPID`"
        exit 1
fi

if [ -f $IPMITOOL ]
then    
    if ! ipmitool sel time set "$DATE" >/dev/null
        then
            echo "Failed to set IPMI sel time"
            exit 1
        fi
else
        echo "Failed to find ipmitool"
        exit 1
fi

# Clear the SEL, we're pushing it into logstash anyway
if ! ipmitool sel clear >/dev/null
then
    echo "Failed to clear sel"
    exit 1
fi
