#!/bin/sh
#provision.sh

RDPWD="password"
RWPWD="password"
PASSWORD="p"
#PASSWORD="Steven!test"
HOST="rwc-fusion-be01.owmessaging.com"
DOM=$1
USERNAME=$2
USERNUM=$3
N=1

cd /opt/builds
./mgr -s $HOST -p 6212 -r $RDPWD -w $RWPWD domain add $DOM services=cal,pab,mail,ps,ups PSSMSCOMPOSEDISABLE=FALSE PSCALSMTPHOST=$DOM PABHOST=PAB1 CALHOST=CAL1 MAILHOSTS=EMS1  >> /opt/builds/provision.log

ERRSTR=`tail -1 /opt/builds/provision.log | awk '{ print $1 }'`
if [ $ERRSTR = "ERROR" ]; then
    echo "Error while creating domain! Please refer /opt/builds/provision.log for reason."
    exit 1
else
    echo "Domain $DOM created successfully"
fi

while [ $N -le $USERNUM ]
do
    MSPATH="/opt/cpowqa/cp/remote/172_20_1_175/ms-HEAD/install/storage/"$DOM"/"$USERNAME$N
    PBPATH="/opt/cpowqa/cp/remote/172_20_1_175/pab-HEAD/install/pab/storage/"$DOM"/"$USERNAME$N
    CALPATH="/opt/cpowqa/cp/remote/172_20_1_175/cal-HEAD/install/storage/"$DOM"/"$USERNAME$N
    NSPATH="/opt/cpowqa/cp/remote/172_20_1_175/ns-HEAD/install/storage/"$DOM"/"$USERNAME$N
    ./mgr -s $HOST -p 6212 -r $RDPWD -w $RWPWD USER ADD $USERNAME$N $DOM services=cal,pab,mail,ps,ups password=$PASSWORD PABHOST=PAB1 CALHOST=CAL1 MAILHOST=EMS1 MAILPATH=$MSPATH PABPATH=$PBPATH CALPATH=$CALPATH  >> /opt/builds/provision.log
    ERRSTR=`tail -1 /opt/builds/provision.log | awk '{ print $1 }'`
    if [ $ERRSTR = "ERROR" ]; then
        echo "Error while creating domain! Please refer /opt/builds/provision.log for reason."
        exit 1
    else 
        echo "User "$USERNAME$N " created!"
    fi
    N=`expr $N + 1`
done
