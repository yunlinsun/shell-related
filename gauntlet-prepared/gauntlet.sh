#/bin/bash
downloadpath=/home/steven/Downloads
bundle_zip=liferay-portal-bundle-tomcat.zip
workspace=/home/steven/project/bundles
unzip_folder=bundles

prepare(){
	echo "Go to workspace..."
	cd $workspace

	if [[ -d "$bundle_zip" ]]; then
		echo "There is $bundle_zip already, will delete it..."
		rm -rf bundle_zip
		echo "Move $bundle_zip to $workspace..."
		mv $downloadpath/$bundle_zip $workspace/$bundle_zip
	else
		echo "Move $bundle_zip to $workspace..."
		mv $downloadpath/$bundle_zip $workspace/$bundle_zip
	fi

	if [[ -d "$unzip_folder" ]]; then
		echo "There is $unzip_folder already, will delete it..."
		rm -rf $unzip_folder
		echo "Unzip $bundle_zip"
		unzip -q ${bundle_zip}
	else
		echo "Unzip $bundle_zip"
		unzip -q ${bundle_zip}
	fi
	echo "[INFO] Please Enter the Branch name of your bundle..."
	echo "[INFO] E.g: 7.0.x_Gauntlet_2018-feb-02_bucket-b_private"
	echo -n "$PS3"
	read branchname
	echo "Move $unzip_folder to $branchname..."
	mv $unzip_folder "$branchname"
	echo "Copy portal-ext.properties to tomcat folder..."
	cp -r $workspace/portal-ext.properties $workspace/$branchname
	echo "Replace setenv.sh..."
	cp -r $workspace/setenv.sh $workspace/$branchname/tomcat-8.0.32/bin

	echo "Clear Database"
	sh ~/mysql.sh
}

prepare
