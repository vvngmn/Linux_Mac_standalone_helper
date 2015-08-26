#!/bin/bash
export INTERMAIL=/var/mxos2
export MXOS_HOME=/var/mxos2
############################################
#   MxOS Start/Stop Script
#
#   version 1.0 - 12/Sept/2011
############################################

zone=`cat /etc/sysconfig/clock | grep ZONE=`
zone=${zone%\"*}
zone="$(echo "$zone" | cut -c7-)"
appDirectory=""


############################################
# Check if mxos variable is set
#
############################################
checkEnv()
{
    if [ -z "$MXOS_HOME" ]
    then
        echo ">>>>> ERROR: Environment variable MXOS_HOME is not defined."
        echo "Aborting ..."
        echo " "
        exit 1
    fi
    
    if [ -z "$INTERMAIL" ]
    then
        echo ">>>>> ERROR: Environment variable INTERMAIL is not defined."
        echo "Aborting ..."
        echo " "
        exit 1
    fi
}

############################################
# Check the mxos status
#
############################################
check_process_status()
{
    if [ ! -f ${PID_FILE_PATH} ]
    then
        return 1
    else
        pid=`cat ${PID_FILE_PATH}`
        pidval=`ps -ef | grep java | grep -v grep|grep "$pid"|awk '{print $2}'`
        if [ "${pidval}" != "" ]
        then
            return 0
        else
            return 1
        fi
    fi
    return 1
}



CATALINA_OPTS=-Duser.timezone=$zone
export CATALINA_OPTS
if [[ $# -ne  1 ]]; then
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
fi

checkEnv

# set PID_FILE_PATH
# for Fusion, the pid file is generated in $INTERMAIL/tmp/ folder
# so we can use imservctrl to start and stop mxos
if [ -d $INTERMAIL/tmp ]; then
    PID_FILE_PATH="$INTERMAIL/tmp/mxos.pid"
else
    # if not existed, generated the pid file in $MXOS_HOME
    PID_FILE_PATH="$MXOS_HOME/mxos.pid"
fi

if [ ! -d $MXOS_HOME/$appDirectory/server ]
then
     echo "$MXOS_HOME/$appDirectory/server directory not found. Check MXOS_HOME env..."
     exit 1
fi

case $1 in
start)
    check_process_status
    ret_val=$?
    if [ $ret_val -eq 0 ]
    then
        echo 'MXOS Server already running'
        exit 1
    fi
    echo ""
    echo "Starting MxOS Server..."
    echo ""
    cd $MXOS_HOME/$appDirectory/server/bin
    ./startup.sh
    exit $?
    ;;
    
stop)
    check_process_status
    ret_val=$?
    if [ $ret_val -ne 0 ]
    then
        echo 'MXOS Server already down'
        exit 1
    fi

    echo ""
    echo "Stopping MxOS Server..."
    echo ""
    cd $MXOS_HOME/$appDirectory/server/bin
    ./shutdown.sh 10 -force
    exit $?
    ;;

restart)
    if [ ! -d $MXOS_HOME/$appDirectory/server ]
    then
        echo ""
        echo "$MXOS_HOME/$appDirectory/server directory not found. Failed to restart mxos..."
        echo ""
    fi
    echo ""
    echo "Stopping MxOS Server..."
    echo ""
    cd $MXOS_HOME/$appDirectory/server/bin
    ./shutdown.sh 10 -force
    check_process_status
    ret_val=$?
    if [ $ret_val -eq 0 ]
    then
            echo 'Failed to shutdown MXOS.'
            exit 1
    fi
    echo ""
    echo "Starting MxOS Server..."
    echo ""
    ./startup.sh
    check_process_status
    ret_val=$?
    if [ $ret_val -eq 1 ]
    then
            echo 'Failed to start MXOS.'
            exit 1
    fi
    exit 0
    ;;
status)
    check_process_status
    ret_val=$?
    if [ $ret_val -eq 0 ]
    then
        # echo 'MXOS Server...up'
        exit 0
    else
        # echo 'MXOS Server...down'
        exit 1
    fi
    ;;
kill)
    check_process_status
    ret_val=$?
    if [ $ret_val -eq 0 ]
    then
        # echo 'MXOS Server...up'
        pid=`cat ${PID_FILE_PATH}`
        kill $pid
        exit $?
    else
        # echo 'MXOS Server...down'
        exit 0
    fi
    ;;
*)
    echo "Usage: $0 {start|stop|restart|status|kill}"
    exit 1
    ;;
esac

exit 0
