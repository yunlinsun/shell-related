#/bin/bash

update(){
echo "[Exec] cd $sourcedir"
cd $sourcedir
echo "[Exec] git fetch upstream"
git fetch upstream
echo "[Exec] git fetch --progress --prune origin"
git fetch --progress --prune origin

for branchname in $branchlist; 
do
	echo "[Exec] git clean -fd"
	git clean -fd
	echo "[Exec] git checkout -f"
	git checkout -f
	echo "[Exec] git checkout $branchname"
	git checkout $branchname
	echo "[Exec] git clean -fd"
	git clean -fd
	echo "[Exec] git checkout -f"
	git checkout -f
	echo "[Exec] git merge --ff-only upstream/$branchname"
	git merge --ff-only upstream/$branchname
	# echo "[Exec] git push origin $branchname"
	# git push origin $branchname
done

echo "[Exec] Done..."
echo -e "[Info] The running time of script is $SECONDS seconds ...\n"
}


branchlist="master 7.0.x"
sourcedir="/home/steven/project/portal"
update
 
branchlist="ee-6.2.10 ee-6.2.x 7.0.x-private master-private"
sourcedir="/home/steven/project/7.0.x-private"
update 

branchlist="6.2.x 7.0.x master"
sourcedir="/home/steven/project/master-portal"
update 