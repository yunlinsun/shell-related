#/bin/bash
logfile=$PWD/log.txt

if [[ -e $logfile ]]; then
 	echo "[INFO] Deleting $logfile..."
 	rm -rfv $logfile
 	echo "[INFO] Done..."
 fi 

while read line
do
 startpos=$(echo $line|awk '{print index($line,"LPS-")}')
 lps=${line:(( $startpos - 1 )):9}
 echo -n "$lps, " >> log.txt
done < $PWD/uitickets.txt
