#/bin/bash

###### Edit to your own ########
Casesfromsheet="/home/steven/project/script/poshi-script/Casesfromsheet.txt" # Creat Casesfromsheet.txt manually, copy & paste value from google sheet.
portal_dir="/home/steven/project/liferay-portal-ee-7.2.x" # Your portal dir ## Example for windows: portal_dir="/d/liferay-portal"
portal_acceptance="stevensun" # Your value
#############################
## Do not edit the following


test_properties="$portal_dir/test.properties"

sed -i 's/LocalFile.//g' $Casesfromsheet

while read line || [[ -n ${line} ]] 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portal_dir -iname)

	string=`grep -A 10 "test $macroname" $file`

	if [[ $string =~ "portal.acceptance" ]]; 
	then
		acceptance_line_start=$(sed -n "/test $macroname/=" $file)
		acceptance_line_end=`echo $((acceptance_line_start+10))`
		sed -i "${acceptance_line_start},${acceptance_line_end}s/portal.acceptance =.*/portal.acceptance = \"$portal_acceptance\"\;/g" $file
	else
		sed "/test $macroname /a \ \ \ \ \ \ \ \ property portal.acceptance \= \"$portal_acceptance\"\; " -i $file	
	fi
done < $Casesfromsheet

LINE_NUM1=$(grep -n "subrepository-validation" $test_properties | cut -f1 -d:)
LINE_NUM2=$(($(grep -n "sequential" $test_properties | cut -f1 -d:)-2))

sed -i "${LINE_NUM1},${LINE_NUM2}c \    test.batch.run.property.query[functional-tomcat90-mysql57-jdk8]=\\\\ \\
	(app.server.types == null OR app.server.types ~ tomcat) AND \\\\ \\
	(database.types == null OR database.types ~ mysql) AND \\\\ \\
	(portal.acceptance == ${portal_acceptance})" $test_properties

LINE_NUM3=$(grep -n "test.batch.names\[acceptance-ce\]\=" $test_properties | cut -f1 -d:)
LINE_NUM4=$(grep -n " wsdd-builder-jdk8" $test_properties | cut -f1 -d:)
sed -i "${LINE_NUM3},${LINE_NUM4}d" $test_properties

LINE_NUM5=$(grep -n "test.batch.names\[acceptance-dxp\]\=" $test_properties | cut -f1 -d:)
LINE_NUM6=$($(grep -n " functional-tomcat90-sqlserver2019-jdk8" $test_properties | cut -f1 -d:)+1)
# LINE_NUM4=$(grep -n -m 1 "#modules-integration-sybase160-jdk8" $test_properties |sed  's/\([0-9]*\).*/\1/')
sed -i "${LINE_NUM5},${LINE_NUM6}c \    test.batch.names\[acceptance-dxp\]\=functional-tomcat90-mysql57-jdk8" $test_properties

sed -i '/test.batch.dist.app.servers=/,+6d' $test_properties

# cd $portal_dir/../modules
# ../gradlew -b util.gradle formatSourceLocalChanges

echo "The script has ran $SECONDS seconds."