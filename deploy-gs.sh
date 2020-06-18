#!/bin/bash

gsType=xap
gsVersion=15.2.0
gsManagerServers=localhost

echo "Please enter GS product type to install default is: [$gsType]"
read newGsType
[ -n "$newGsType" ] && gsType=$newGsType
echo $gsType

echo "Please enter your GS version to install default is: [$gsVersion]"
read newGsVersion
[ -n "$newGsVersion" ] && gsVersion=$newGsVersion
echo $gsVersion

echo "Please enter your GS_MANAGER_SERVERS default is: [$gsManagerServers]"
read newGsManagerServers
[ -n "$newGsManagerServers" ] && gsManagerServers=$newGsManagerServers
echo $gsManagerServers

function installRemoteJava {
	sudo yum -y install java-1.8.0-openjdk	
	echo "install Remote JDK - Done!"
}

function installZip {
	sudo yum -y install unzip	
	echo "install ZIP - Done!"
}

function installWget {
	sudo yum -y install wget	
	echo "install wget - Done!"
}

function downloadGS {
	wget https://gigaspaces-releases-eu.s3.amazonaws.com/${gsType}/${gsVersion}/gigaspaces-${gsType}-enterprise-${gsVersion}.zip	
	echo "download GS - Done!"
}

function unzipGS {
        unzip gigaspaces-${gsType}-enterprise-${gsVersion}.zip	
	echo "unzipping GS - Done!"
}

function activateGS {
        echo "Product=InsightEdge;Version=15.2;Type=ENTERPRISE;Customer=deShow_demo_DEV;Expiration=2020-Sep-12;Hash=RSQNeYbSzNPSUOINZQrK">gigaspaces-${gsType}-enterprise-${gsVersion}/gs-license.txt 
	echo "activating GS - Done!"
}

function startGS {
        nohup gigaspaces-${gsType}-enterprise-${gsVersion}/bin/gs.sh host run-agent --auto &
	echo "starting GS - Done!"
        echo "GS Web-UI http://localhost:8099"
        echo "GS Ops Manager http://localhost:8090"
}

function endAnnouncement {
echo "#######################################################"
echo "SUMMARY :  SYSTEM INSTALLED SUCCESSFULLY"
echo DATE `date +"%D"` / TIME `date +"%T"`
echo "VERSION ${gsType}"
echo "URL for OpsManager :  <.   >."
echo "URL for GS web-ui :   <.     >."
echo "URL for Zeppelin NoteBook <   >"
echo "Rest :   <. >"
echo "#######################################################"
}

if [ "$1" == "-h" ]; then
  echo "For cluster setup:"
  echo "Usage: `basename $0` [GS_Manager_Host1,GS_Manager_Host2,GS_Manager_Host3]"
  echo "For none cluster installation (one host) no paramter is required, the installation will be based on machine localhost"
  exit 0
fi
echo "setup java"
installRemoteJava
echo "setp zip"
installZip
echo "install wget"
installWget
echo "Download GS"
downloadGS
echo "unzipping GS"
unzipGS
echo "activating GS"
activateGS
if [ "$1" != "" ]; then
	echo "setting manager GS"
	echo -e "\nexport GS_MANAGER_SERVERS=$gsManagerServers">>gigaspaces-${gsType}-enterprise-${gsVersion}/bin/setenv-overrides.sh 	
	echo "setting manager GS - Done!"
fi
echo "starting GS"
startGS
echo "ending the Installation"
endAnnouncement

