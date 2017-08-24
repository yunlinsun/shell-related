#/bin/bash

USER="root"
dblist="test test1 master ee70x ee6210 ee62x"

#crate database
for dbname in $dblist; do
	mysql -u $USER -e "drop database if exists $dbname; show databases; create database $dbname;"
done