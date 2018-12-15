#/bin/bash

###### For linux User ########
Casesfromsheet="/home/steven/project/script/poshi-script/Casesfromsheet.txt" # Creat Casesfromsheet.txt manually, copy & paste value from google sheet.
portalweb_dir="/home/steven/project/liferay-portal-ee/portal-web" # Your portal-web dir ## Example for windows: portalweb_dir="/d/Git/portal/70/portal-web"
portal_acceptance="stevensun" # Your value
#############################
## Do not edit the following


test_properties="$portalweb_dir/../test.properties"

sed -i 's/LocalFile.//g' $Casesfromsheet

while read line 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portalweb_dir -name) 
	sed "/test $macroname /a\        property portal.acceptance \= \"$portal_acceptance\"\; " -i $file
done < $Casesfromsheet

set -v

LINE_NUM1=$(sed -n '/    test.batch.names\=/=' $test_properties)
LINE_NUM2=$(sed -n '/    wsdd-builder-jdk8/=' $test_properties)
sed -i "${LINE_NUM1},${LINE_NUM2}c test.batch.names\=functional-smoke-tomcat90-mysql57-jdk8" $test_properties

LINE_NUM3=$(sed -n '/test.batch.run.property.query\[functional-smoke-tomcat90-mysql57-jdk8\]\=/=' $test_properties)
sed -i "${LINE_NUM3}s/^.*$/        test.batch.run.property.query\[functional-smoke-tomcat90-mysql57-jdk8\]\=portal.acceptance\ \=\=\ $portal_acceptance/" $test_properties
sed -i '/test.batch.dist.app.servers=/,+6d' $test_properties


cd $portalweb_dir/../modules
../gradlew -b util.gradle formatSourceLocalChanges

echo "The script has ran $SECONDS seconds."