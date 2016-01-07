#!/bin/bash
# Argument = -u user -p password -t target_name -c config -s schedule -v

usage()
{
cat << EOF
usage: $0 options

This script creates OpenVAS tasks

OPTIONS:
   -h      Show this message
   -u      OpenVAS username
   -p      OpenVAS password
   -t      Target name
   -c      Config name
   -s      Schedule name ( optional )
   -v      Verbose
EOF
}

USER=
PASSWD=
TARGET=
CONFIG=
VERBOSE=

while getopts “hu:p:t:c:s:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
     u)
         USER=$OPTARG
         ;;
         p)
             PASSWD=$OPTARG
             ;;
         t)
             TARGET=$OPTARG
             ;;
         c)
             CONFIG=$OPTARG
             ;;
     s)
         SCHEDULE=$OPTARG
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

if [[ -z $USER ]] || [[ -z $PASSWD ]] || [[ -z $TARGET ]] || [[ -z $CONFIG ]]
then
     usage
     exit 1
fi

if omp -u $USER -w $PASSWD --get-tasks | grep -w $TARGET >/dev/null
then
    echo "$TARGET task already exists"
    exit 1
fi

TARGET_ID=`omp -u $USER -w $PASSWD --get-targets | grep -w $TARGET | cut -d ' ' -f 1`
if [[ -z $TARGET_ID ]]
then
    echo "Could not find target $TARGET"
    exit 1
fi

CONFIG_ID=`omp -u $USER -w $PASSWD --get-configs | grep -w "$CONFIG$" | cut -d ' ' -f 1`
if [[ -z $CONFIG_ID ]]
then
    echo "Could not find config $CONFIG"
    exit 1
fi

if [[ $SCHEDULE ]]
then
    SCHEDULE_ID=`omp -u $USER -w $PASSWD -X "<get_schedules filter=\"$SCHEDULE\"/>" -i | grep 'schedule id' | cut -d '=' -f 2 | sed 's/.//;s/..$//'`
    if [[ $SCHEDULE_ID ]]
    then
        TASK_ID=`omp -u $USER -w $PASSWD -X "<create_task><name>$TARGET</name><config id=\"$CONFIG_ID\"/><target id=\"$TARGET_ID\"/><schedule id=\"$SCHEDULE_ID\"/></create_task>"`
    else
        echo "Could not find schedule $SCHEDULE"
        exit 1
    fi
else
    TASK_ID=`omp -u $USER -w $PASSWD -C -n $TARGET --config=$CONFIG_ID --target=$TARGET_ID`
fi

if [[ -z $TASK_ID ]]
then
    echo "Could not create task"
    exit 1
fi
