#!/bin/bash

#!/bin/bash

# Tomcat UX (Otosan/Kiwi/Koala) uninstall script
# - Stops and uninstalls tomcat
#
# Eamon Doyle, June 2015
# Copyright (C) 2015 Openwave Messaging. All rights reserved.
#

VERSION=1.03

# Configuration params
#
TOMCAT=apache-tomcat-7.0.62
TOMCAT_START=$TOMCAT/bin/startup.sh
TOMCAT_STOP=$TOMCAT/bin/shutdown.sh
TOMCAT_ARCHIVE=$TOMCAT.tar.gz
IP_ADDRESS=10.128.21.94
TOMCAT_HOSTNAME=$IP_ADDRESS
PORT=8080
DIRECTORY=./

MODES=('koala' 'kiwi-octane' 'otosan')
MODE=otosan
#MODE=kiwi-octane

STARTTIME=$(date +%s)

usage()
{
    echo "Tomcat UX uninstall script, Version: $VERSION"
    echo "Usage:"
    echo "./tomcat-ux-install.sh [-a <ip>] [-p <port>] [-d <dir>] [-m <mode>] [-v]"
    echo "Options:"
    echo "   -h, --help        show this help and exit"
    echo "   -a <ip>, --address <ip>"
    echo "                     IP address tomcat server should listen on"
    echo "   -d <dir>, --directory <dir>"
    echo "                     location on disk where tomcat should be installed"
    echo "   -m, --mode        choice of <otosan|kiwi-octane|koala>, default otosan"
    echo "   -p <n>, --port <n>"
    echo "                     port tomcat server should listen use"
    echo "   -v, --verbose     script debug output"
}


wait_tomcat_stops()
{
    if [ ! -e $CATALINA_PID ]; then
        return
    fi

    pid=$(cat $CATALINA_PID)
    echo "### Waiting on tomcat process $pid to complete"
    sleep 10
    loop=0
    while ps -p $pid > /dev/null; do
        echo "### Tomcat process still active, pid=$pid..."
        ((loop++))
        if [[ $loop -eq 1 ]]; then
            echo "### Attempting to kill tomcat process pid=$pid..."
            kill $pid
        fi
        if [[ $loop -eq 5 ]]; then
            echo "### Attempting to kill -9 tomcat process pid=$pid..."
            kill -9 $pid
            break
        fi
        sleep 5
    done;
}


wipe_tomcat()
{
    done=0

    if [ -e $TOMCAT_ARCHIVE ]; then
        rm $TOMCAT_ARCHIVE
        ((done++))
    fi

    if [ -e $TOMCAT ]; then
        rm -rf $TOMCAT
        ((done++))
    fi

    if [ -e $WAR_FILE ]; then
        rm $WAR_FILE
        ((done++))
    fi

    if [[ $loop -eq 0 ]]; then
        echo "### Environment not present, nothing to remove"
    else
        echo "### Tomcat environment and archives wiped"
    fi
}


get_tomcat_hostname()
{
    resp=`getent hosts $IP_ADDRESS`
    eval arr=($resp)
    TOMCAT_HOSTNAME=${arr[1]}
}


#########
# Parse command line args
#
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -a|--address)
            IP_ADDRESS="$2"
            shift # past argument
            ;;
        -d|--directory)
            DIRECTORY="$2"
            shift # past argument
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -m|--mode)
            MODE="$2"
            shift # past argument
            ;;
        -p|--port)
            PORT="$2"
            shift # past argument
            ;;
        -v|--verbose)
            VERBOSE=1
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done

if [[ ! "${MODES[@]}" =~ "${MODE}" ]]; then
    echo "### Unsupported mode $MODE, please choose from ${MODES[@]}"
    exit 1
fi

WAR_FILE=$MODE.war

if [ $VERBOSE -eq 1 ]; then
    set -x
fi

#########
# change to directory location, then get full path
#
pushd $DIRECTORY
DIRECTORY=${PWD}
HOSTNAME=${HOSTNAME}
NOW=$(date)
get_tomcat_hostname

echo "#####################################################"
echo "### Uninstalling Tomcat UX installation as follows...."
echo "### DATE          = $NOW"
echo "### BUILD         = $BUILD_ID ($BUILD_NUMBER)"
echo "### BUILD_TAG     = $BUILD_TAG"
echo "### MODE          = $MODE"
echo "### HOST          = $HOSTNAME"
echo "### TOMCAT        = $TOMCAT"
echo "### IP_ADDRESS    = $IP_ADDRESS"
echo "### TOMCAT_HOST   = $TOMCAT_HOSTNAME"
echo "### DIRECTORY     = ${PWD}"
echo "### PORT          = $PORT"
echo "### VERBOSE       = $VERBOSE"
echo "### VERSION       = $VERSION"
echo "###"

#########
# configure environment
#
CATALINA_HOME=$DIRECTORY/$TOMCAT
export CATALINA_HOME=$CATALINA_HOME
CATALINA_PID=$DIRECTORY/$TOMCAT/.pid
export CATALINA_PID=$CATALINA_PID
JRE_HOME=/usr/local/jdk1.7.0_21/
export JRE_HOME=$JRE_HOME


echo "### Wiping existing tomcat environment (within $DIRECTORY/$TOMCAT)..."
nc -z $IP_ADDRESS $PORT
if [ $? -eq 0 ]; then
    if [ -e $TOMCAT_STOP ]; then
        echo "### Existing tomcat service appears active, stopping...."
        $TOMCAT_STOP
    fi
fi
wait_tomcat_stops
wipe_tomcat


ENDTIME=$(date +%s)
ELAPSED=$(($ENDTIME - $STARTTIME))
echo "### Uninstall completed in $ELAPSED seconds"
echo "###"
echo "### Success: Tomcat/UX uninstall complete"
echo "#####################################################"
