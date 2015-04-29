#!/bin/bash
WARNING=0
CRITICAL=0
UNKNOWN=0
# This is all fairly complex, here's some relevant background
# http://www.mjmwired.net/kernel/Documentation/iostats.txt
# http://www.xaprb.com/blog/2010/01/09/how-linux-iostat-computes-its-results/

# Here's the basic assumptions for drive types
# A WD Black SATA 3 drive can do upwards of 150MB/s
# Warn if we're doing half of that on average either way
# IOPS benchmarking shows 140+ on read and 220+ on write
# so base warn and critical on that
# These figures are IOPS, Read KB/s, Write KB/s
HDD_WARNPS_PARAMS=(100 75000 75000)
HDD_CRITPS_PARAMS=(200 100000 100000)
# This is queue depth in number of operations
# Warn, Critical
# Finger in the wind on these numbers
# iostat shows this generally under 1
HDD_QUEUE_PARAMS=(5 10)
# Average wait times in ms
# Roughly the time it takes to service an IO
# Warn, Critical
# A disk under heavy load in Ceph usually
# takes average 50-60ms, spiking to 130ms
HDD_WAIT_PARAMS=(180 200)
# PNY SSD 500MB/s seq read, 320MB/s seq write
# 60K IOPS rd, 35K IOPS write
# As above thse are IOPS, Read KB/s, Write KB/s
SSD_WARNPS_PARAMS=(30000 300000 200000)
SSD_CRITPS_PARAMS=(50000 400000 300000)
SSD_QUEUE_PARAMS=(5 10)
SSD_WAIT_PARAMS=(10 20)

readdiskstat() {
    if [ ! -f "/sys/block/$1/stat" ]; then
        return 3
    fi
    cat /sys/block/"$1"/stat
}

readhistdiskstat() {
    [ -f "$HISTFILE" ] && cat "$HISTFILE"
}


################
# SCRIPT START #
################
FACTER=$(which facter)
if [ -z "$FACTER" ]
then
   echo "This script requires facter"
   exit 3
fi

# Get the list of disks from facter
# Read into an array for processing later
DISKS=$($FACTER -p | grep blockdevices | awk '{print $3}')
IFS='","' read -ra DISK_ARRAY <<< "$DISKS"

# Check each disk
for DISK in "${DISK_ARRAY[@]}"; do
    # generate HISTFILE filename
    HISTFILE=/var/tmp/check_diskstat_$(id -nu).$DISK
    # Set the correct parameters dependening on type
    DISK_TYPE=$(cat /sys/block/"$DISK"/queue/rotational)
    if [ "$DISK_TYPE" -eq 1 ]
    then
	    # Spinning disk params
	    WARNPS_PARAMS=("${HDD_WARNPS_PARAMS[@]}")
	    CRITPS_PARAMS=("${HDD_CRITPS_PARAMS[@]}")
	    QUEUE_PARAMS=("${HDD_QUEUE_PARAMS[@]}")
	    WAIT_PARAMS=("${HDD_WAIT_PARAMS[@]}")
    else
	    # SSD params
	    WARNPS_PARAMS=("${SSD_WARNPS_PARAMS[@]}")
	    CRITPS_PARAMS=("${SSD_CRITPS_PARAMS[@]}")
	    QUEUE_PARAMS=("${SSD_QUEUE_PARAMS[@]}")
	    WAIT_PARAMS=("${SSD_WAIT_PARAMS[@]}")
    fi
    # Process the thresholds
    WARN_IOPS="${WARNPS_PARAMS[0]}"
    WARN_READ="${WARNPS_PARAMS[1]}"
    WARN_WRITE="${WARNPS_PARAMS[2]}"
    CRIT_IOPS="${CRITPS_PARAMS[0]}"
    CRIT_READ="${CRITPS_PARAMS[1]}"
    CRIT_WRITE="${CRITPS_PARAMS[2]}"
    WARN_QSZ="${QUEUE_PARAMS[0]}"
    CRIT_QSZ="${QUEUE_PARAMS[1]}"
    WARN_WAIT="${WAIT_PARAMS[0]}"
    CRIT_WAIT="${WAIT_PARAMS[1]}"

    NEWDISKSTAT=$(readdiskstat "$DISK")
    if [ $? -eq 3 ]
    then
        echo "UNKNOWN: Cannot read disk stats, check your /sys filesystem for $DISK"
        exit 3
    fi

    if [ ! -f "$HISTFILE" ]
    then
        echo "$NEWDISKSTAT" > "$HISTFILE"
        OUTPUT+="Initial buffer creation for $DISK"
        ((UNKNOWN++))
        continue
    fi

    OLDDISKSTAT=$(readhistdiskstat)
    if [ $? -ne 0 ]
    then
        echo "UNKNOWN: Cannot read histfile $HISTFILE..."
        exit 3
    fi

    # now we have old and current stats load the variables for comparison
    # These are in kernel block sectors
    OLD_SECTORS_READ=$(echo "$OLDDISKSTAT" | awk '{print $3}')
    NEW_SECTORS_READ=$(echo "$NEWDISKSTAT" | awk '{print $3}')
    OLD_SECTORS_WRITTEN=$(echo "$OLDDISKSTAT" | awk '{print $7}')
    NEW_SECTORS_WRITTEN=$(echo "$NEWDISKSTAT" | awk '{print $7}')
    # Read and write are in IO's
    OLD_READ=$(echo "$OLDDISKSTAT" | awk '{print $1}')
    NEW_READ=$(echo "$NEWDISKSTAT" | awk '{print $1}')
    OLD_WRITE=$(echo "$OLDDISKSTAT" | awk '{print $5}')
    NEW_WRITE=$(echo "$NEWDISKSTAT" | awk '{print $5}')
    
    # Calculate times
    OLDDISKSTAT_TIME=$(stat "$HISTFILE" | grep Modify | sed 's/^.*: \(.*\)$/\1/')
    OLDDISKSTAT_EPOCH=$(date -d "$OLDDISKSTAT_TIME" +%s)
    NEWDISKSTAT_EPOCH=$(date +%s)
    # Elapsed time in seconds since last run
    let "TIME = $NEWDISKSTAT_EPOCH - $OLDDISKSTAT_EPOCH"
    
    # kernel handles sectors by 512bytes
    # http://www.mjmwired.net/kernel/Documentation/block/stat.txt
    # http://www.mjmwired.net/kernel/Documentation/iostats.txt
    SECTORBYTESIZE=512
    # Calculate sectors and covert to bytes and kilobytes 
    let "SECTORS_READ = $NEW_SECTORS_READ - $OLD_SECTORS_READ"
    let "SECTORS_WRITE = $NEW_SECTORS_WRITTEN - $OLD_SECTORS_WRITTEN"
    let "BYTES_READ_PER_SEC = $SECTORS_READ * $SECTORBYTESIZE / $TIME"
    let "BYTES_WRITTEN_PER_SEC = $SECTORS_WRITE * $SECTORBYTESIZE / $TIME"
    let "KBYTES_READ_PER_SEC = $BYTES_READ_PER_SEC / 1024"
    let "KBYTES_WRITTEN_PER_SEC = $BYTES_WRITTEN_PER_SEC / 1024"
    
    # Average number of IOPS
    let "NR_IOS = $NEW_READ - $OLD_READ + $NEW_WRITE - $OLD_WRITE"
    let "IOPS = $NR_IOS / $TIME"

    # Read and write ticks and time in queue are in milliseconds
    OLD_WAITTIME_READ=$(echo "$OLDDISKSTAT" | awk '{print $4}')
    NEW_WAITTIME_READ=$(echo "$NEWDISKSTAT" | awk '{print $4}')
    let "READ_TICKS = $NEW_WAITTIME_READ - $OLD_WAITTIME_READ" 
    OLD_WAITTIME_WRITE=$(echo "$OLDDISKSTAT" | awk '{print $8}')
    NEW_WAITTIME_WRITE=$(echo "$NEWDISKSTAT" | awk '{print $8}')
    let "WRITE_TICKS = $NEW_WAITTIME_WRITE - $OLD_WAITTIME_WRITE"
    OLD_TIMEINQ=$(echo "$OLDDISKSTAT" | awk '{print $11}')
    NEW_TIMEINQ=$(echo "$NEWDISKSTAT" | awk '{print $11}')
    let "TIMEINQ = $NEW_TIMEINQ - $OLD_TIMEINQ"
    #: $((++$NR_IOPS)) ; : $((--$NR_IOPS))
    
    # TIME is in seconds, TIMEINQ is in milliseconds
    # What we are looking for here is the average number of requests in the queue
    # http://www.xaprb.com/blog/2010/01/09/how-linux-iostat-computes-its-results/
    let "AQUSZ = ( $TIMEINQ / ( $TIME * 1000))"
    
    if [[ $NR_IOPS -ne 0 ]]; then
        # Average wait
        let "AWAIT = ( $READ_TICKS + $WRITE_TICKS ) / $NR_IOPS"
        # Average request size if we ever need it
        # let "ARQSZ = ( $SECTORS_READ + $SECTORS_WRITE ) / $NR_IOS"
    else
        AWAIT=0
        # ARQSZ=0
    fi

    # Check IOPS
    if [ "$IOPS" -gt "$WARN_IOPS" ]; then
        if [ "$IOPS" -gt "$CRIT_IOPS" ]; then
            OUTPUT+="IO/s on $DISK (>$CRIT_TPS), "
            ((CRITICAL++))
        else
            OUTPUT+="IO/s on $DISK (>$WARN_TPS), "
            ((WARNING++))
        fi
    fi
    # Check read rates
    if [ "$KBYTES_READ_PER_SEC" -gt "$WARN_READ" ]; then
        if [ "$KBYTES_READ_PER_SEC" -gt "$CRIT_READ" ]; then
            OUTPUT+="Read KB/s on $DISK (>$CRIT_READ), "
            ((CRITICAL++))
        else
            OUTPUT+="Read KB/s on $DISK (>$WARN_READ), "
            ((WARNING++))
        fi
    fi

    # Check write rates
    if [ "$KBYTES_WRITTEN_PER_SEC" -gt "$WARN_WRITE" ]; then
        if [ "$KBYTES_WRITTEN_PER_SEC" -gt "$CRIT_WRITE" ]; then
            OUTPUT+="Write KB/s on $DISK (>$CRIT_WRITE), "
            ((CRITICAL++))
        else
            OUTPUT="Write KB/s on $DISK (>$WARN_WRITE), "
            ((WARNING++))
        fi
    fi
    
    # Check WARN_QSZ
    if [ "$AQUSZ" -gt "$WARN_QSZ" ]; then
        if [ "$AQUSZ" -gt "$CRIT_QSZ" ]; then
            OUTPUT+="Queue size on $DISK (>$CRIT_QSZ), "
            ((CRITICAL++))
        else
            OUTPUT+="Queue size on $DISK (>$WARN_QSZ), "
            ((WARNING++))
        fi
    fi

    # Check AWAIT
    if [ "$AWAIT" -gt "$WARN_WAIT" ]; then
        if [ "$AWAIT" -gt "$CRIT_WAIT" ]; then
            OUTPUT+="Wait times on $DISK (>$CRIT_AWAIT), "
            ((CRITICAL++))
        else
            OUTPUT+="Wait times on $DISK (>$WARN_AWAIT), "
        fi
    fi

done

if [ "$CRITICAL" -ne 0 ]
then
    echo "CRITICAL: $OUTPUT"
    exit 2
fi
if [ "$WARNING" -ne 0 ]
then
    echo "WARNING: $OUTPUT"
    exit 1
fi
if [ $UNKNOWN -ne 0 ]
then
    echo "UNKNOWN: $OUTPUT"
    exit 3
fi
echo "OK: All disks performing within normal limits"
echo "$NEWDISKSTAT" > "$HISTFILE"
exit 0
