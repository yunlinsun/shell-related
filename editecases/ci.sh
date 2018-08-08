#/bin/bash

###### For linux User ########
Casesfromsheet="/home/steven/project/script/poshi-script/Casesfromsheet.txt" # Creat Casesfromsheet.txt manually, copy & paste value from google sheet.
portalweb_dir="/home/steven/project/liferay-portal-ee/portal-web" # Your portal-web dir
replacevalue='		<property name="portal.acceptance" value="stevensun" />' # Your property
#############################
## Do not edit the following
test_properties="$portalweb_dir/../test.properties"

sed -i 's/LocalFile.//g' $Casesfromsheet

while read line 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portalweb_dir -name) 
	sed "/command name=\"$macroname\"/a\\$replacevalue" -i $file
done < $Casesfromsheet

set -v

sed -i '1214s/^.*$/test.batch.run.property.query\[functional-tomcat80-mysql56-jdk8\]\=portal.acceptance \=\= stevensun/' $test_properties
sed -i '1103,1180c test.batch.names\=functional-tomcat80-mysql56-jdk8' $test_properties
sed -i '/test.batch.dist.app.servers=\\/,+6d' $test_properties


cd $portalweb_dir/../modules
../gradlew -b util.gradle formatSourceLocalChanges

echo "The script has ran $SECONDS seconds."