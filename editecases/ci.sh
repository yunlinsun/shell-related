#/bin/bash

###### For linux User ########
Casesfromsheet="/home/steven/project/script/poshi-script/Casesfromsheet.txt" # Creat Casesfromsheet.txt manually, copy & paste value from google sheet.
portalweb_dir="/home/steven/project/liferay-portal/portal-web" # Your portal-web dir ## Example for windows: portalweb_dir="/d/Git/portal/70/portal-web"
portal_acceptance="stevensun" # Your value
#############################
## Do not edit the following


test_properties="$portalweb_dir/../test.properties"

sed -i 's/LocalFile.//g' $Casesfromsheet

while read line || [[ -n ${line} ]] 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portalweb_dir -iname) 
	sed "/test $macroname /a\                property portal.acceptance \= \"$portal_acceptance\"\; " -i $file
done < $Casesfromsheet

set -v

LINE_NUM1=$(sed -n '/    test.batch.names\[acceptance-ce\]\=/=' $test_properties)
LINE_NUM2=$(sed -n '/    wsdd-builder-jdk8/=' $test_properties)

sed -i "${LINE_NUM1},${LINE_NUM2}d" $test_properties

LINE_NUM3=$(sed -n '/    test.batch.names\[acceptance-dxp\]\=/=' $test_properties)
LINE_NUM4=$(grep -n -m 1 "#modules-integration-sybase160-jdk8" $test_properties |sed  's/\([0-9]*\).*/\1/')


sed -i "${LINE_NUM3},${LINE_NUM4}c \    test.batch.names\[acceptance-dxp\]\=functional-tomcat90-mysql57-jdk8" $test_properties

LINE_NUM5=$(sed -n '/test.batch.run.property.query\[functional-tomcat90-mysql57-jdk8\]\=/=' $test_properties)
sed -i "${LINE_NUM5}s/^.*$/    test.batch.run.property.query\[functional-tomcat90-mysql57-jdk8\]\=portal.acceptance\ \=\=\ $portal_acceptance/" $test_properties
sed -i '/test.batch.dist.app.servers=/,+6d' $test_properties


# cd $portalweb_dir/../modules
# ../gradlew -b util.gradle formatSourceLocalChanges

echo "The script has ran $SECONDS seconds."