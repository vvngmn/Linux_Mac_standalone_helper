#!/bin/bash

echo '**********************************'
echo 'login 123 - clear war'
echo '**********************************'
ssh root@172.20.1.123 "cd /opt/imail1/webtop/webapps/kiwi-octane/;ls /opt/imail1/webtop/webapps/kiwi-octane/|grep kiwi-octane.*.war |xargs rm"

