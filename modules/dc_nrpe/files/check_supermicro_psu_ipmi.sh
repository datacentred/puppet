#!/bin/bash
#
#  Uses ipmi tool to get Supermicro power supply status.  This works
#  on the X8 class motherboards and may or may not require changes to
#  work on other motherboards and chassis.
#
#  Copyright (c) 2010, tummy.com, ltd., All Rights Reserved.
#  Written by Kyle Anderson, tummy.com, ltd.
#  Under the GPL v2 License 

# check for plugin directory where utils.sh lives
[ -d /usr/lib/nagios/plugins ]   && UTILPATH=/usr/lib/nagios/plugins
[ -d /usr/lib64/nagios/plugins ] && UTILPATH=/usr/lib64/nagios/plugins
#  load states and strings
if [ -x "$UTILPATH"/utils.sh ]; then
        . "$UTILPATH"/utils.sh
else
        echo "ERROR: Cannot find utils.sh"
        exit
fi

if ! which ipmitool >/dev/null 2>&1; then
	echo "ERROR: No ipmitool found in my path"
	exit $STATE_UNKNOWN
fi

#Secret RAW IPMI Commands Passed down from Supermicro Sages
POWER1=`ipmitool raw 0x06 0x52 0x07 0x78 0x01 0x78 2>&1`
POWER2=`ipmitool raw 0x06 0x52 0x07 0x7a 0x01 0x78 2>&1`

# These commands only work on the sled in slot A
# We have no way of testing this so assume the error means we're in slot B
if [[ $POWER1 == *"Unable to send RAW command"* ]]
then
	echo "OK: PSU check on sled in slot A"
	exit $STATE_OK
fi

if [ "$POWER1" == ' 01' ] && [ "$POWER2" == ' 01' ] ; then 
	echo "OK: Power supply status OK"
	exit $STATE_OK
elif [ "$POWER1" != ' 01' ]; then
	echo "CRITICAL: Power Supply 1 failure"
        exit $STATE_CRITICAL
elif [ "$POWER2" != ' 01' ]; then
	echo "CRITICAL: Power Supply 2 failure"
        exit $STATE_CRITICAL
fi
