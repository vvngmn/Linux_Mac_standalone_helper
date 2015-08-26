#!/bin/bash
echo '**********************************************'
echo 'begin to start the sevices of 172.20.1.126: scality and nginx'
echo '**********************************************'



ssh root@172.20.0.129 su - root << EOF
/etc/init.d/scality-rest-connector stop
/etc/init.d/scality-sagentd stop
/etc/init.d/scality-node stop
/etc/init.d/scality-sagentd start
/etc/init.d/scality-rest-connector start
/etc/init.d/scality-node start
/etc/init.d/httpd restart
sleep 5
server_num=\`ps -aux |grep  scality|wc -l\`
if [[ \$server_num -eq 32 ]]
then
   echo "129 scality server startup successfully============="
else
   echo "129 scality server startup fail================"
fi

curl -d "username=root&password=admin" "http://172.20.0.129:3080/login"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8084/0/join"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8085/0/join"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8086/0/join"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8087/0/join"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8088/0/join"
curl -d "b=1" "http://172.20.0.129:3080/sup/Local/scalityRing/node/172.20.0.129:8089/0/join"
exit
EOF

python /root/startscality.py 172.20.0.129 # join scality nodes by selenium

ssh root@172.20.1.126 su - root << EOF
/etc/init.d/scality-rest-connector stop
/etc/init.d/scality-sagentd stop
/etc/init.d/scality-node stop
/etc/init.d/scality-sagentd start
/etc/init.d/scality-rest-connector start
/etc/init.d/scality-node start
/etc/init.d/httpd restart
sleep 5
server_num=\`ps -aux |grep  scality|wc -l\`
if [[ \$server_num -eq 32 ]]
then
   echo "126 scality server startup successfully============="
else
   echo "126 scality server startup fail================"
fi

curl -d "username=root&password=admin" "http://172.20.1.126:3080/login"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8084/0/join"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8085/0/join"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8086/0/join"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8087/0/join"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8088/0/join"
curl -d "b=1" "http://172.20.1.126:3080/sup/Local/scalityRing/node/172.20.1.126:8089/0/join"
exit
EOF

python /root/startscality.py 172.20.1.126 # join scality nodes by selenium

ssh root@172.20.1.126 su - imail1 << EOF
~/nginx1.4.1/scripts/nginx restart
return_code1=\`echo $?\`
if [[ \$return_code1 -eq 0 ]]
then
   echo "nginx server is starting============="
else
   echo "nginx need to restart================"
fi
sleep 5
serve_num=\`ps -aux |grep  nginx|wc -l\`
if [[ \$serve_num -eq 50 ]]
then
   echo "nginx server startup successfully=========="
else
   echo "nginx server startup fail================"
fi
exit

EOF




echo '**********************************************'
echo 'begin to start the sevices of 172.20.1.123'
echo '**********************************************'

ssh root@172.20.1.123 su - imail1 << EOF
~/apache-cassandra-1.2.15/metadata/bin/cassandra

serve_num=\`ps -aux |grep  cass|wc -l\`
if [[ \$serve_num -eq 3 ]]
then
   echo "cassandra server startup successfully=========="
else
   echo "cassandra server startup fail================"
fi
exit

EOF


echo '**********************************************'
echo 'begin to start the sevices of 172.20.1.126 : mxos'
echo '**********************************************'
ssh root@172.20.1.126 su - imail1 <<EOF
~/lib/imservctrl killStart mxos
sleep 2
server_num=\`imservping |grep mxos|wc -l\`
if [[ \$server_num -eq 1 ]]
then
   echo "mxos server startup successfully=========="
else
   echo "mxos server startup fail================"
fi


~/lib/imservctrl killStart
return_code=\`echo $?\`
if [[ \$return_code -eq 0 ]]
then
   echo "126 server is started============="
else
   echo "126 fail to start================"
fi


~/lib/imservctrl killStart pabd

sleep 5 
serv_num=\`imservping|wc -l\`
if [[ \$serv_num -eq 4 ]]
then
   echo "pab2 server is started============="
else
   echo "pab2 faile to start================"
fi
exit
EOF

echo '**********************************************'
echo 'begin to start the sevices of 172.20.1.124'
echo '**********************************************'

ssh root@172.20.1.124 su - imail1 <<EOF
~/lib/imservctrl killStart
return_code=\`echo $?\`
if [[ \$return_code -eq 0 ]]
then
   echo "mss1 server on 124 is starting============="
else
   echo "mss1 on 124 failed to start================"
fi

sleep 5 
serv_num=\`imservping|wc -l\`
if [[ \$serv_num -eq 10 ]]
then
   echo "mss1 server on 124 startup successfully=========="
else
   echo "mss1 server on 124 startup fail================"
fi
exit
EOF

echo '**********************************************'
echo 'begin to start the sevices of 172.20.1.125'
echo '**********************************************'

ssh root@172.20.1.125 su - imail1 <<EOF
~/lib/imservctrl killStart
return_code=\`echo $?\`
if [[ \$return_code -eq 0 ]]
then
   echo "mss2 server is starting============="
else
   echo "mss2 need to restart================"
fi


~/lib/imservctrl killStart pabd


sleep 5 
serv_num=\`imservping|wc -l\`
if [[ \$serv_num -eq 4 ]]
then
   echo "mss2 pab capd server startup successfully=========="
else
   echo "mss2 pab capd server startup fail================"
fi
exit
EOF

ssh root@172.20.1.123 su - imail1 << EOF
sh /opt/imail1/webtop/bin/startup.sh
EOF

ssh root@172.20.1.126 su - imail1 << EOF
~/lib/imservctrl killStart pabd
EOF
