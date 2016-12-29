#/bin/bash

##Introducton
#This is a script for prepare your legency bundle and auto install patch.
#Reference: https://gist.github.com/anthony-chu/1503854a1efb5e743544#file-release-sh
#Enjoy!


baseDir=$PWD

clean(){
	if [[ -e $liferayHome ]]; then
		echo "[INFO] Deleting liferay home..."
		rm -rf $liferayHome
		echo "[INFO] Done."
	fi


	echo "[INFO] Unzipping a new bundle for Liferay Portal ${releaseVersion}..."
	unzip -q ${zipFile}
	echo "[INFO] Done."

	echo "[INFO] Writing portal-ext.properties..."
	extFile=$baseDir/portal-ext.properties
	cp $extFile $liferayHome/

	if [[ $OS =~ Windows ]]; then
		_temp=${liferayHome/\//}
		temp=${_temp^}
		_liferayHome=${temp:0:1}":"${temp:1:${#temp}}
		echo -e "\n\nliferay.home=$_liferayHome" >> $liferayHome/portal-ext.properties
	else
		echo -e "\n\nliferay.home=$liferayHome" >> $liferayHome/portal-ext.properties
	fi

	echo "[INFO] Done."

	tomcatDir=${liferayHome}/tomcat-${_tomcatVersion}

	echo "[INFO] Getting mysql.jar..."
	cp -r mysql.jar $tomcatDir/lib/ext
	echo "[INFO] Done."

	echo "[INFO] Increasing JVM options..."
	sed -i "s/-Xmx1024m/-Xms1024m -Xmx2048m/g" $tomcatDir/bin/setenv.sh
	sed -i "s/MaxPermSize=256m/MaxPermSize=1024m/g" $tomcatDir/bin/setenv.sh
	sed -i "s/MaxPermSize=384m/MaxPermSize=1024m/g" $tomcatDir/bin/setenv.sh

	if [[ $patchName -eq No ]]; then
		echo "[INFO] No Patch will be installed..."
	else
		echo "[INFO] Copying $patchZip..."
		cp $patchZip $patchPath/patches
		echo "[INFO] Done."

		echo "[INFO] Starting patching-tool info..."
		$patchPath/patching-tool.sh info
		echo "[INFO] Done."

		echo "[INFO] Starting patching-tool install..."
		$patchPath/patching-tool.sh install
		echo "[INFO] Done."				
	fi

	if [[ ! -e ${liferayHome}/deploy ]]; then
		echo "[INFO] Creating deploy directory..."
		mkdir ${liferayHome}/deploy
		echo "[INFO] Done."
	fi

	if [[ -f clean.sh ]]; then
		echo "[INFO] Getting clean.sh..."
		cp clean.sh ${liferayHome}
		echo "[INFO] Done."
	fi

	echo "[INFO] Copying license for ${minorVersion} EE..."
	license=*development*${minorVersion}*.xml
	cp $baseDir/$license $liferayHome/deploy
	echo "[INFO] Done."

	echo "[INFO] Done."
	echo "[INFO] The running time of the script is $SECONDS seconds"
}

clear
if [ $# -eq 0 ]; then
	echo "Usage: release.sh ( commands )"
	echo "	clean - Unzips and prepares a new instance of the selected portal version"

else
	echo "[INFO] Please Enter the Liferay EE Portal that you want run"
	echo "[INFO] E.g.: If you want run 6.2.10.18. Just type '4' and Press Enter"
	echo ""
	PS3="Please Enter:  "
	echo ""
	select releaseVersion in "6.0.12" "6.1.30.5" "6.2.10.1" "6.2.10.18" "7.0.10" "7.0.10.1"
	do
	minorVersion=${releaseVersion:0:3}
	if [[ $minorVersion == 6.0 ]]; then
		liferayHome=${baseDir}/liferay-portal-${minorVersion}-ee-sp2
		_tomcatVersion=6.0.32
		zipFile=liferay-portal-tomcat-${minorVersion}*.zip
	elif [[ $minorVersion == 6.1 ]]; then
		liferayHome=${baseDir}/liferay-portal-${minorVersion}-ee-ga3-sp5
		_tomcatVersion=7.0.40
		zipFile=liferay-portal-tomcat-${minorVersion}*.zip
	elif [[ $releaseVersion == 6.2.10.1 ]]; then
		liferayHome=${baseDir}/liferay-portal-${releaseVersion}-ee-ga1
		_tomcatVersion=7.0.42
		zipFile=liferay-portal-tomcat-${releaseVersion}*ga*.zip
	elif [[ $releaseVersion == 6.2.10.18 ]]; then
		liferayHome=${baseDir}/liferay-portal-${minorVersion}-ee-sp$(( ${releaseVersion/${minorVersion}.10./} - 1 ))
		_tomcatVersion=7.0.62
		zipFile=liferay-portal-tomcat-${minorVersion}*sp$(( ${releaseVersion/${minorVersion}.10./} - 1 ))*.zip	
	elif [[ $releaseVersion == 7.0.10 ]]; then
		liferayHome=${baseDir}/liferay-dxp-digital-enterprise-${minorVersion}-ga1
		_tomcatVersion=8.0.32
		zipFile=liferay-dxp-digital-enterprise-tomcat-7.0-ga1-20160617092557801.zip
	elif [[ $releaseVersion == 7.0.10.1 ]]; then
		liferayHome=${baseDir}/liferay-dxp-digital-enterprise-${minorVersion}-sp$(( ${releaseVersion/${minorVersion}.10./} ))
		_tomcatVersion=8.0.32
		zipFile=liferay-dxp-digital-enterprise-tomcat-7.0-sp$(( ${releaseVersion/${minorVersion}.10./} ))*.zip
	else
		echo "[ERROR] Please select a valid Liferay EE version."
		exit
	fi

	echo "[INFO] Please Enter the Patch name that you want to install"
	echo "[INFO] E.g: [64-6130] or [130-6210] or [10-7010] or [No]"
	echo -n "$PS3"
	read patchName

	if [ $patchName="^[0-9]-6130" ]||[ $patchName="^[0-9]-6210" ]||[ $patchName="^[0-9]-7010" ]; then
		patchZip=liferay-fix-pack-*-${patchName}-*.zip
		patchPath=${liferayHome}/patching-tool	
	elif [[ $patchName -eq "No" ]]; then
		echo "[INFO] No patch will be installed"
		echo ""
	else
		echo "[ERROR] Please enter a valid Patch version."
		echo ""
		exit
	fi

	break
	done

	while [ $# -gt 0 ]; do
		$1
		shift
	done
fi