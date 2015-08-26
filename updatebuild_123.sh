#!/bin/bash
echo '**********************************************'
echo 'mkdir'
echo '**********************************************'
mkdir /opt/imail1/webtop/webapps/kiwi-octane_$1

echo '**********************************************'
echo 'local - copy war from 63 to 123'
echo '**********************************************'
cd /home/kiwi_octane_build
# localwar=`ls |grep kiwi-octane.war`
scp root@10.13.6.63/home/kiwi_octane_build/kiwi-octane.war /opt/imail1/webtop/webapps/kiwi-octane_$1

echo '**********************************************'
echo 'unzip war, update config, restart tomcat'
echo '**********************************************'
cd /opt/imail1/webtop/webapps/kiwi-octane_$1
# war=`ls |grep kiwi-octane.war`
# unzip $war
unzip kiwi-octane.war

cp /root/webtop-config.xml /opt/imail1/webtop/webapps/kiwi-octane_$1/WEB-INF/classes/config/

su - imail1 << EOF
tomcatpid=`ps -ef|grep tomcat|awk 'NR==1 {print $2}'`
kill -9 $tomcatpid
sh /opt/imail1/webtop/bin/startup.sh
exit
EOF


 