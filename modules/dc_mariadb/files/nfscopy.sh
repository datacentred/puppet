#!/bin/sh

# Check the remote directory is mounted
if cat /proc/mounts | grep -q /var/dbbackups-remote
then
    rsync -a --delete /var/dbbackups/ /var/dbbackups-remote/
else
    echo "Remote directory does not seem to be mounted"
    exit 1
fi
