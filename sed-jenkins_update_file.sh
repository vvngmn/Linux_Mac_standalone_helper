cd /home/mx_json/webtop_api_test/webtop_json/testsuite
# update the request link for HostPort in resources

folder=`ssh root@172.20.1.123 "ls -t /opt/imail1/webtop/webapps/|head -1"`
sed -i "s#http://172.20.1.123:8080/kiwi-octane'#http://172.20.1.123:8080/$folder'#g" ../resource/resource-mx-contact_JSON-cass.py

folder=`ssh root@172.20.1.123 "ls -t /opt/imail1/webtop/webapps/|head -1"`
sed -i "s#http://172.20.1.123:8080/kiwi-octane'#http://172.20.1.123:8080/$folder'#g" ../resource/resource-mx-mail_JSON-cass.py

folder=`ssh root@172.20.1.123 "ls -t /opt/imail1/webtop/webapps/|head -1"`
sed -i "s#http://172.20.1.123:8080/kiwi-octane'#http://172.20.1.123:8080/$folder'#g" ../resource/resource-mx-calendar_JSON-cass.py