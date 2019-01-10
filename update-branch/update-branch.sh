#/bin/bash

update(){
cd $sourcedir
git fetch upstream --no-tags


for branchname in $branchlist; 
do
	git clean -fd
	git checkout -f
	git checkout $branchname
	git clean -fd
	git checkout -f
	git merge --ff-only upstream/$branchname
	git push --set-upstream origin $branchname
done

echo -e "[Info] The running time of script is $SECONDS seconds ...\n"
}

set -x

branchlist="7.0.x 7.1.x 7.2.x master"
sourcedir="/home/steven/project/liferay-portal"
update

branchlist="master-private 7.1.x-private 7.0.x-private ee-6.2.x ee-6.2.10 7.0.x master 7.2.x 7.1.x"
sourcedir="/home/steven/project/liferay-portal-ee"
update 

branchlist="ee-6.2.x ee-7.0.x 7.0.x-private"
sourcedir="/home/steven/project/plugins-ee"
update 

# branchlist="master"
# sourcedir="/home/steven/project/liferay-jenkins-ee"
# update

# branchlist="2.x master"
# sourcedir="/home/steven/project/liferay-blade-samples"
# update