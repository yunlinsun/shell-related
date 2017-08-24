#/bin/bash

USER="root"
dblist="test test1 master ee70x ee6210 ee62x"
TIMESTAMP=`date +%Y%m%d%H%M%S`

#crate database
for dbname in $dblist; do
	mysql -u $USER -e "drop database if exists $dbname; show databases; create database $dbname;"
done
