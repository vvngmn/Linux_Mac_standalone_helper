#!/bin/sh


InstallDir="/opt/cpowqa/cp/remote/172_20_1_175"

export NPLEX_CONFIG=$InstallDir/cpath
export NPLEX_RMAP=$InstallDir/cpath

echo "***************** Starting DSA ***************************"
echo 
su - dsamgr -c 'cd iCon/DSA;odsstart'
echo 
echo "********************************************"

echo "***************** Starting PAB Server ***************************"
$InstallDir/pab-HEAD/install/pab/bin/pabrc restart
echo  
echo "********************************************"

#echo "***************** Starting  NS ***************************"
#$InstallDir/ns-HEAD/install/bin/cpnsrc restart
#echo  
#echo "********************************************"


echo "***************** Starting  FS ***************************"
#$InstallDir/fs-HEAD/install/bin/fs.sh stop
$InstallDir/fs-HEAD/install/bin/fs.sh start
echo  
echo "********************************************"

echo "***************** Starting CAL Server  ***************************"
$InstallDir/cal-HEAD/install/bin/cpcal restart
echo  
echo "********************************************"

echo "***************** Starting MS Server  ***************************"
$InstallDir/ms-HEAD/install/global/bin/nplexrc restart
echo  
echo "********************************************"


