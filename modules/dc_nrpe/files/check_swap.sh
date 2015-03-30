#!/bin/bash
# 
# Plugin to check free swap
# using check_by_ssh
# by Markus Walther (voltshock@gmx.de)
# The script needs a working check_by_ssh connection and needs to run on the client to check it
# 
# Command-Line for check_by_ssh
# command_line    $USER1$/check_by_ssh -H $HOSTNAME$ -p $ARG1$ -C "$ARG2$ $ARG3$ $ARG4$ $ARG5$ $ARG6$"
# 
# Command-Line for service (example)
# check_by_ssh!82!/nagios/check_swap.sh!50!20
#
##########################################################
case $1 in
  --help | -h )
        echo "Usage: check_swap [warn] [crit]"
        echo " [warn] and [crit] as int"
        echo " Example: check_swap 20 10"
        exit 3
         ;;
  * )
    ;;
esac

warn=$1
crit=$2

if [ ! "$1" -o ! "$2" ]; then
        echo "Usage: check_swap [warn] [crit]"
        echo " [warn] and [crit] as int"
        echo " Example: check_swap 20 10"
        echo "Unknown: Options missing: using default (warn=20, crit=10)"
        warn=`echo $((20))`
        crit=`echo $((10))`
fi

full=`free | grep Swap | sed -r 's/\ +/\ /g' | cut -d \  -f 2`
free=`free | grep Swap | sed -r 's/\ +/\ /g' | cut -d \  -f 4`

if [ "$warn" -lt "$crit" -o "$warn" -eq "$crit" ]; then
   echo "Unknown: [warn] must be larger than [crit]"
        exit 3
fi

use=`echo $(( ($free * 100) / $full ))`

if [ "$use" -gt "$warn" -o "$use" -eq "$warn" ]; then
        echo "OK: $use% free swap"
        exit 0
 elif [ "$use" -lt "$warn" -a "$use" -gt "$crit" ]; then
        echo "Warning: $use% free swap"
        exit 1
 elif [ "$use" -eq "$crit" -o "$use" -lt "$crit" ]; then
        echo "Critical: $use% free swap"
        exit 2
 else
        echo "Unknown"
        exit 3
fi

