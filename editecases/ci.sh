#/bin/bash
Casesfromsheet=/home/steven/project/script/poshi-script/Casesfromsheet.txt # Creat Casesfromsheet.txt manually, copy & paste value from google sheet.
portalweb_dir=/home/steven/project/liferay-portal-ee/portal-web # Your portal-web dir
replacevalue='		<property name="portal.acceptance" value="stevensun" />' # Your property

#############################
## Do not edit the following

sed -i 's/LocalFile.//g' $Casesfromsheet

while read line 
do
	casename=`echo $line|cut -f1 -d "#"`
	macroname=`echo $line|cut -f2 -d "#"`
	file=$(echo $casename.testcase | xargs find $portalweb_dir -name) 
	sed "/command name=\"$macroname\"/a\\$replacevalue" -i $file
done < $Casesfromsheet