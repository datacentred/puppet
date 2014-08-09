#!/bin/sh

# Check the remote directory is mounted and mount if it's not there
if ! grep -q /var/dbbackups-remote /proc/mounts
then
    if mount /var/dbbackups-remote
    then
        rsync -a --delete /var/dbbackups/ /var/dbbackups-remote/
    else
        echo "Cannot mount remote directory"
        exit 1
    fi
fi
if ! umount /var/dbbackups-remote
then
    echo "Cannot unmount remote directory"
    exit 1
fi
