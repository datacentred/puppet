#!/bin/bash
mem_bytes=`cat /proc/meminfo | grep MemTotal | cut -d " " -f 8`
mem_gigabytes=$((mem_bytes/1000000))
mem_expected=$1
disks_expected=$2
usage()
{
cat << EOF
usage: $0 options

This check for Nagios tests the CPU and Memory size against expected value.

OPTIONS:
   -h      Show this message
   -m      Amount of expected memory in GB
   -c      Number of expected CPU's
   -v      Verbose
EOF
}

debug_echo()
{
if [ $VERBOSE != 0 ]
then
	echo $1
fi
}

VERBOSE=0
ERRORS=0
while getopts ":m:c:vh" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         m)
             MEM=$OPTARG
	     if ! [[ $MEM = *[[:digit:]] ]]
	     then
		echo "Memory must be a number in GB"
		exit
	     fi
             ;;
         c)
             CPU=$OPTARG
	     if ! [[ $CPU = *[[:digit:]] ]]
	     then
		echo "CPU must be a number of cores"
		exit
	     fi
             ;;
         v)
             VERBOSE=1
            ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [ -z ${CPU+x} ] || [ -z ${MEM+x} ]
then
	echo "CPU and Memory are mandatory"
	exit
fi

# Script start

mem_bytes=`cat /proc/meminfo | grep MemTotal | cut -d " " -f 8`
mem_gigabytes=$((mem_bytes/1000000))
cpu_actual=`cat /proc/cpuinfo | grep processor | wc -l`

debug_echo "Actual memory is $mem_bytes in bytes"
debug_echo "Actual memory is $mem_gigabytes GB"
debug_echo "Number of CPU's is $cpu_actual"
debug_echo "Expected CPU's is $CPU"
debug_echo "Expected memory is $MEM GB"

if (( $MEM < $mem_gigabytes ))
then
	debug_echo "More memory than expected"
	((++ERRORS))
	error_message="Memory was $mem_gigabytes GB, expecting $MEM GB"
elif (( $MEM > $mem_gigabytes ))
then
	debug_echo "Less memory then expected"
	error_message="Memory was $mem_gigabytes GB, expecting $MEM GB"
	((++ERRORS))
else
	debug_echo "Memory is correct"
fi

if (( $CPU < $cpu_actual ))
then
	debug_echo "More CPU's than expected"
	((++ERRORS))
	error_message="$error_message Number of CPU's was $cpu_actual, expecting $CPU"
elif (( $CPU > $cpu_actual ))
then
	debug_echo "Less CPU's then expected"
	error_message="$error_message Number of CPU's was $cpu_actual, expecting $CPU"
	((++ERRORS))
else
	debug_echo "CPU is correct"
fi


if [ $ERRORS != 0 ]
then
	debug_echo "Errors is $ERRORS"
	echo "CRITICAL - $error_message"
	exit 2
else
	echo "OK - hardware configuration looks correct"
	exit 0
fi
