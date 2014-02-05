#!/bin/sh

# Check the remote directory is mounted
if cat /proc/mounts | grep -q /var/dbbackups-remote
then
    for file in ls /var/dbbackups
    do if ! cp /var/dbbackups/$file /var/dbbackups-remote
    then
        echo "Could not copy $file - exiting"
        exit 1
    fi
    done
else
    echo "Remote directory does not seem to be mounted"
    exit 1
fi
