#!/bin/bash
#
# Cinder Volume monitoring script

# Copyright © 2013 eNovance <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Requirement: netstat
#

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
DAEMON='cinder-volume'

usage ()
{
    echo "Usage: $0 [OPTIONS]"
    echo " -h               Get help"
    echo "No parameter : Just run the script"
}

while getopts 'h' OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if ! which netstat >/dev/null 2>&1
then
    echo "netstat is not installed."
    exit $STATE_UNKNOWN
fi

MASTER_PID=$(ps -ef | awk "BEGIN {FS=\" \"}{if (/python(2.7)? [^ ]+${DAEMON}/) {print \$2 ; exit}}")

if [[ -z $MASTER_PID ]]; then
    echo "$DAEMON is not running."
    exit $STATE_CRITICAL
fi

CHILD_PID=$(ps h --ppid ${MASTER_PID} -o pid)

if [[ -z $CHILD_PID ]]; then
    echo "$DAEMON is not running."
    exit $STATE_CRITICAL
fi

if [[ "$(id -u)" != "0" ]]; then
    echo "$DAEMON is running but the script must be run as root"
    exit $STATE_WARNING
else

    #Need root to "run netstat -p"
    for PID in $CHILD_PID ; do
        if ! KEY=$(netstat -epta 2>/dev/null | awk "{if (/amqp.*${PID}\/python/) {print ; exit}}") || test -z "$KEY"
        then
            echo "$DAEMON is not connected to AMQP"
            exit $STATE_CRITICAL
        fi
    done
fi

echo "$DAEMON is working."
exit $STATE_OK
