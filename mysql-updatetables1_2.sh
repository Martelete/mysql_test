#!/bin/bash

# Security improvements. Credentials been moved in a secure location
# Output improved avoding unsecure login warning

# VARIABLES 
DIR=/git/mysql_test

# UPGRADE DB
# for cycle is to set as variable all the file into the directory
for i in $(ls -l $DIR | grep -v total) ; do
	# LASTVERSION is storing the last version
	LASTVERSION=`mysql -s -N -e "select version from test_mysql.versionTable"`
	# The version will take just the numbers in the first 5 characters
	VERSION=$(echo $i | cut -c1-5 | sed 's/[^0-9]*//g')
	# if the db version is greater or equal then the sql file do not execute it ###
	if [ "$LASTVERSION" -ge "$VERSION" ] ; then
		 # this will print which sql script will not work
		echo "the script $i will not work"
	#run the sql script and update the db
	else
		# ths is to print out which sql script is actual running 
		echo "the sql script $i is running"
		# the following command will upgrade tables 
		mysql < ${DIR}/${i}
		echo "$New version updated successfully"
		# the following update will "update" the db version 
		mysql -e "update test_mysql.versionTable SET version='$VERSION' where version ='$LASTVERSION'"
		echo "VersionTable updated. Current version is: $VERSION"
	fi
done
