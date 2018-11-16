#/bin/bash
###############Edit the following to your path################
workspace=/home/steven/fix-pack/dependencies
bundles_dir=/home/steven/fix-pack/fp-bundles
sp9=liferay-dxp-digital-enterprise-tomcat-7.0.10.9-sp9-20181030140307011.zip
portal_ext=/home/steven/fix-pack/dependencies/portal-ext.properties
patching_tool_zip=/home/steven/fix-pack/dependencies/patching-tool-2.0.8.zip
license=/home/steven/fix-pack/dependencies/activation-key-development-7.0de-liferaycom.xml
###############################


unzip_file(){
	echo "[INFO] clean $bundles_dir"
	rm -rf $bundles_dir/*
	echo "[INFO] Please enter the bundle.zip file name, then press Enter"
	echo " Do not type anything if you want to use dxp-sp9 tomcat"
	read zip_file

	if [[ -e $zip_file ]]; then
		unzip -q $zip_file -d $bundles_dir
	else
		unzip -q $sp9 -d $bundles_dir
	fi
}

# Place mysql.jar
place_related_files(){
	for file in $(find $bundles_dir -name hsql.jar -print)
	do
    	jar_dir=$(dirname $file)
    	echo "[INFO] hsql.jar's dir is $jar_dir..."
    	echo "[INFO] Place related jars to $jar_dir"
		cp -r $workspace/mysql.jar $workspace/ojdbc7.jar $workspace/db*.jar $jar_dir
		echo "[INFO] Place portal-ext into $bundles_dir"
		cp -r $portal_ext $bundles_dir/*/
	done	
}

replace_plugins_for_sp9(){
	echo "[INFO] Copy $workspace/sp9-plugins/* into $bundles_dir/osgi/marketplace"
	cp -r $workspace/sp9-plugins/* $bundles_dir/*/osgi/marketplace
}

replace_patching-tool(){
	echo "[INFO] Delete the original patching-tool folder"
	rm -rf $bundles_dir/*/patching-tool
	echo "[INFO] Unzip $patching_tool_zip into $bundles_dir/*/"
	unzip -q $patching_tool_zip -d $bundles_dir/*/
}

install_patch(){
	echo "[INFO]   Please input the patch number you are testing"
	read patch_no
	echo "[INFO] Copy patch into patching-tool folder"
	cp -r liferay-fix-pack-*${patch_no}*.zip $bundles_dir/*/patching-tool/patches
	echo "[INFO] Go to patching-tool folder"
	cd $bundles_dir/*/patching-tool

	for command in {auto-discovery,info,install}; do
			echo "[INFO] ./patching-tool.sh $command"			
			./patching-tool.sh $command
			echo " "
		done	
}

check_revert(){
	echo "[INFO]   Please input the patch number you are testing"
	read patch_no
	echo "[INFO] Copy patch into patching-tool folder"
	cp -r liferay-fix-pack-*${patch_no}*.zip $bundles_dir/*/patching-tool/patches
	echo "[INFO] Go to patching-tool folder"
	cd $bundles_dir/*/patching-tool

	for command in {auto-discovery,info,install,info,revert,info,install,info}; do
			echo "[INFO] ./patching-tool.sh $command"			
			./patching-tool.sh $command
			echo " "
		done	
}

for func in {unzip_file,place_related_files}; do
	$func
done

if [[ $1 == -p ]]; then
	# replace_plugins_for_sp9
	replace_patching-tool
	install_patch
	elif [[ $1 == -r ]]; then
		replace_patching-tool
		check_revert	
fi

sh ~/mysql.sh	
echo "[INFO]  The running time of script is $SECONDS seconds"