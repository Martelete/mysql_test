#!/bin/bash

# VARIABLES 
DIR=/git/mysql_test
DBNAME=test_mysql
DBUSER=user
DBPASS=password
DBHOST=localhost

# UPGRADE DB
# for cycle is to set as variable all the file into the directory 
for i in $(ls -l $SCRIPTDIR | grep -v total) ; do
	# LASTVERSION is storing the last version
	LASTVERSION=$(mysql -u $DBUSER -p$DBPASS $DBNAME <<< 'select version from versionTable;' |grep -v version)
	# The script version 
	VERSION=$(echo $i | cut -c1-5 | sed 's/[^0-9]*//g')
	# if the db version is greater or equal then the sql file do not execute it 
	if [ "$LASTVERSION" -ge "$VERSION" ] ; then
		# this will print which sql script will not work
		echo "the script $i will not work"
	# run the sql script and update the db 
	else
		# ths is to print out which sql script is actual running 
		echo "the sql script $i is running"
		# the following command will upgrade tables 
		mysql -u $DBUSER -p$DBPASS $DBNAME < ${DIR}/${i}
		echo "$New version updated successfully"
		# the following update will "update" the db version
		mysql -u $DBUSER -p$DBPASS $DBNAME <<< 'update versionTable SET version='$VERSION' where version ='$LASTVERSION';'
		echo "VersionTable updated. Current version is: $VERSION"
	fi
done
