#/bin/bash
branchlist="ee-6.2.10 ee-6.2.x 7.0.x 7.0.x-private master master-private"
sourcedir="/home/steven/project/portal"


	echo "[Exec] cd $sourcedir"
	cd $sourcedir
	echo "[Exec] git fetch upstream"
	git fetch upstream

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
	git merge upstream/$branchname
	# echo "[Exec] git push origin $branchname"
	# git push origin $branchname
done

echo "[Exec] Done..."
echo "[Info] The running time of script is $SECONDS seconds ..."