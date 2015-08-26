#!/bin/bash

n=`date '+%m%d'`
echo '**********************************************'
echo 'login 123 - mkdir'
echo '**********************************************'
ssh root@172.20.1.123 su - imail1 <<EOF
mkdir /opt/imail1/webtop/webapps/kiwi-octane_$n
EOF


echo '**********************************************'
echo 'local - copy war to 123'
echo '**********************************************'
cd /home/kiwi_octane_build
# localwar=`ls |grep kiwi-octane.war`
scp /home/kiwi_octane_build/kiwi-octane.war root@172.20.1.123:/opt/imail1/webtop/webapps/kiwi-octane_$n

echo '**********************************************'
echo 'login 123 - unzip war'
echo '**********************************************'
ssh root@172.20.1.123 su - root << EOF
cd /opt/imail1/webtop/webapps/kiwi-octane_$n
unzip kiwi-octane.war
exit
EOF

echo '**********************************************'
echo 'local - backup and make a new config'
echo '**********************************************'
# scp /home/kiwi_octane_build/webtop-config.xml root@172.20.1.123:/opt/imail1/webtop/webapps/kiwi-octane_$n/WEB-INF/classes/config/webtop-config_backup.xml
ssh root@172.20.1.123 su - root << EOF
cd /opt/imail1/webtop/webapps/kiwi-octane_$n/WEB-INF/classes/config/
cp webtop-config.xml webtop-config_backup.xml

sed -i 's#mxos url="http://.*:8081/mxos"#mxos url="http://172.20.1.126:8081/mxos"#g' webtop-config.xml
sed -i 's#service uri="http://.*:.*/webtop-media"#service uri="http://172.20.1.123:8080/webtop-media"#g' webtop-config.xml
sed -i 's#store protocol="imap" host=".*" port=".*"#store protocol="imap" host="172.20.1.124" port="10143" starttls="false"#g' webtop-config.xml
sed -i 's#transport protocol="smtp" host=".*" port=".*"#transport protocol="smtp" host="172.20.1.124" port="10025" auth="false" starttls="false"#g' webtop-config.xml
sed -i 's#calDavServer host=".*" port=".*"#calDavServer host="172.20.1.125" port="5229" webappContext="/calendars" trashEnabled="true" proxyHost="proxyHost" proxyPort="1234"#g' webtop-config.xml

sed -i 's#rsvp url="http://.*:8080/kiwi-octane.*"#rsvp url="http://172.20.1.123:8080/kiwi-octane_'"$n"'"#g' webtop-config.xml
sed -i 's#http://.*:8080/kiwi-octane.*/http/shareCalendar#http://172.20.1.123:8080/kiwi-octane_'"$n"'/http/shareCalendar#g' webtop-config.xml

sed -i 's#userDomain value=".*"#userDomain value="openwave.com"#g' webtop-config.xml
sed -i 's#allowCalDomain value=".*"#allowCalDomain value="openwave.com"#g' webtop-config.xml



EOF

echo '**********************************************'
echo 'login 123 - restart tomcat'
echo '**********************************************'
ssh root@172.20.1.123 su - imail1 << EOF
tomcatpid=`ps -ef|grep tomcat|awk 'NR==1 {print $2}'`
kill -9 $tomcatpid
sh /opt/imail1/webtop/bin/startup.sh
exit
EOF


 
 
