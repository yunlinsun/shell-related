#/bin/bash

###### Edit to your own ########
casesfromcsv="/home/steven/project/script/poshi-script/casesfromcsv.txt" # Creat casesfromcsv.txt manually, copy & paste value from case_results.csv.
portal_dir="/home/steven/project/liferay-portal-ee-7.3.x" # Your portal dir ## Example for windows: portal_dir="/d/liferay-portal"
portal_acceptance="stevensun" # Your value


#############################
## Do not edit the following


test_properties="$portal_dir/test.properties"

sed -i 's/LocalFile.//g' $casesfromcsv

while read line || [[ -n ${line} ]] 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portal_dir/portal-web $portal_dir/modules -iname)

	string=`grep -A 10 "test $macroname " $file`

	if [[ $string =~ "portal.acceptance" ]]; 
	then
		acceptance_line_start=$(sed -n "/test $macroname /=" $file)
		let acceptance_line_end=acceptance_line_start+10
		sed -i "${acceptance_line_start},${acceptance_line_end}s/portal.acceptance =.*/portal.acceptance = \"$portal_acceptance\"\;/g" $file
	else
		sed "/test $macroname /a \ \ \ \ \ \ \ \ property portal.acceptance \= \"$portal_acceptance\"\; " -i $file	
	fi
done < $casesfromcsv

LINE_NUM1=`grep -n "test.batch.run.property.query\[functional-tomcat90-mysql57-jdk8\]\=" $test_properties | cut -f1 -d:`
let LINE_NUM2=LINE_NUM1+3
sed -i "${LINE_NUM2}s/true/$portal_acceptance/" $test_properties

LINE_NUM3=`grep -n "test.batch.names\[acceptance-ce\]\=" $test_properties | cut -f1 -d:`
LINE_NUM4TEMP=`grep -n " # Acceptance (DXP)" $test_properties | cut -f1 -d:`
let LINE_NUM4=LINE_NUM4TEMP-3
sed -i "${LINE_NUM3},${LINE_NUM4}c \    test.batch.names\[acceptance-ce\]\=functional-tomcat90-mysql57-jdk8" $test_properties

LINE_NUM5=`grep -n "test.batch.names\[acceptance-dxp\]\=" $test_properties | cut -f1 -d:`
let LINE_NUM6=LINE_NUM5+10
sed -i "${LINE_NUM5},${LINE_NUM6}c \    test.batch.names\[acceptance-dxp\]\=\$\{test.batch.names\[acceptance-ce\]\}" $test_properties

bundle_line_number1=`grep -n "test.batch.dist.app.servers\[bundles\]\=" $test_properties | cut -f1 -d:`
let bundle_line_number2=bundle_line_number1+5
sed -i "${bundle_line_number1},${bundle_line_number2}c \ test.batch.dist.app.servers\[bundles\]\=" $test_properties

dist_number1=`grep -n "test.batch.dist.app.servers\=" $test_properties | cut -f1 -d:`
let dist_number2=dist_number1+5
sed -i "${dist_number1},${dist_number2}c \test.batch.dist.app.servers\=tomcat" $test_properties

echo "The script has ran $SECONDS seconds."