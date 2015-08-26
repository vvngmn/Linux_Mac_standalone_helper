ssh root@172.20.0.78
su - imail1
cd lib
echo checking status
service_status=`imservping | awk '{print $8     $9}'`
echo $service_status
exit; exit; exit

# ssh root@172.20.0.79
# su - mxos
# cd scripts
# sh mxos.sh restart
# exit; exit
