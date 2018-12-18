#/bin/bash
downloadpath=/home/steven/Downloads
bundle_zip=7.1.x_Gauntlet_2018-dec-13_bucket-a_private.tar.gz
workspace=/home/steven/project/bundles
unzip_folder=bundles

prepare(){
	echo "Go to workspace..."
	cd $workspace

	if [[ -d "$unzip_folder" ]]; then
		echo "There is $unzip_folder already, will delete it..."
		rm -rf $unzip_folder
		tar -xvf $downloadpath/$bundle_zip -C $workspace
		 
	else
		echo "Unzip $bundle_zip" to $workspace
		tar -xvf $downloadpath/$bundle_zip -C $workspace
	fi	
	echo "[INFO] Please Enter the Branch name of your bundle..."
	echo "[INFO] E.g: 7.0.x_Gauntlet_2018-feb-02_bucket-b_private"
	echo -n "$PS3"
	read branchname
	echo "Move $bundle_zip to ${branchname}.zip..."
	mv $downloadpath/$bundle_zip "$downloadpath/${branchname}.zip"
	echo "Move $unzip_folder to $branchname..."
	mv $unzip_folder "$branchname"
	echo "Copy portal-ext.properties to tomcat folder..."
	cp -r $workspace/portal-ext.properties $workspace/$branchname
	echo "Copy setenv.sh to tomcat folder..."
	cp -r $workspace/setenv.sh $workspace/$branchname/tomcat*/bin

	# echo "Clear Database"
	# sh ~/mysql.sh
	echo "PWD: $workspace/$branchname"
}

prepare