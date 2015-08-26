#!/bin/bash
echo '**********************************************'
echo 'login 123 - mkdir'
echo '**********************************************'
ssh root@172.20.1.123 su - imail1 <<EOF
mkdir /opt/imail1/webtop/webapps/kiwi-octane_$1
EOF


echo '**********************************************'
echo 'local - copy war to 123'
echo '**********************************************'
cd /home/kiwi_octane_build
# localwar=`ls |grep kiwi-octane.war`
scp /home/kiwi_octane_build/kiwi-octane.war root@172.20.1.123:/opt/imail1/webtop/webapps/kiwi-octane_$1

echo '**********************************************'
echo 'login 123 - unzip war, update config, restart tomcat'
echo '**********************************************'
ssh root@172.20.1.123 su - root << EOF
cd /opt/imail1/webtop/webapps/kiwi-octane_$1
unzip kiwi-octane.war
exit
EOF

scp /home/kiwi_octane_build/webtop-config.xml root@172.20.1.123:/opt/imail1/webtop/webapps/kiwi-octane_$1/WEB-INF/classes/config/

ssh root@172.20.1.123 su - imail1 << EOF
tomcatpid=`ps -ef|grep tomcat|awk 'NR==1 {print $2}'`
kill -9 $tomcatpid
sh /opt/imail1/webtop/bin/startup.sh
exit
EOF

echo '**********************************************'
echo 'local - clear build #echo $localwar|xargs rm'
echo '**********************************************'
 
 