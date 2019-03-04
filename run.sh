#!/bin/bash

/etc/init.d/mysqld start
mysql -e "create database test_mysql"
mysql -e "create table test_mysql.versionTable (version int(5))"
mysql -e "insert into test_mysql.versionTable (version) values (001)"
