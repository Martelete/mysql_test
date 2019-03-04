   
By running this bash script it will update to the lastest version. It can be run via Docker also. This option will need to create a Dockerfile to build in the container and run.


- Initially, make sure mysql server is installed with libraries and is up and running.
- Create a folder directory called "/tmp/mysql-scripts".
- copy and create two files for those scripts; one called "UPDATE_MYSQL_1_1.sh" and the second one "UPDATE_MYSQL_1_2.sh" in your local machine directory.
- Create empty files according to the tables (EX.3).
- Please make sure username and password is setup under "~/.my.cfn" for MySQL (as per my user and password setup).
- If the instance is created run the query "select version from versionTable;"
- Change the script folder variable in the script and fill it with empty files (EX.3)
- run the script: ./mysql-update_mysql_1_1.sh and then ./mysql-update_mysql_1_2.sh

EX.1

UPDATE_MYSQL_1_1.sh

#!/bin/bash

# variables
DIR=/tmp/mysql_scripts
DBNAME=test_mysql
DBUSER=user_mysql
DBPASS=password_mysql
DBHOST=localhost

# upgrading db 
	for i in $(ls -l $DIR | grep -v total); do
	# update to LASTESTVERSION 
	LASTESTVERSION=$(mysql -u $DBUSER -p$DBPASS $DBNAME <<< 'select version from versionTable;' | grep -v version)
	VERSION=$(echo $i | cut -c1-3 | sed 's/[^0-9]*//g')
	# db version greater equal then the sql file will not work
	if [ "$LASTESTVERSION" -ge "$VERSION" ]; then
		echo "the script $i does not work"
	else
		echo "the script $i is work"
		# the following command will upgrade tables
		mysql -u $DBUSER -p$DBPASS $DBNAME < ${DIR}/${i}
		echo "$SUCCESSFULLY UPDATED"
		# the following update will "update" the DB version 
		mysql -u $DBUSER -p$DBPASS $DBNAME <<< 'update versionTable SET version='$VERSION' where version ='$LASTESTVERSION';'
		echo "New version updated successfully. Current version is: $VERSION"
	fi
done

----------------------------------------------------------------------------------------------------------------------------
EX.2

UPDATE_MYSQL_1_2.sh

# variables
DIR=/tmp/mysql_scripts

# upgrading db
for i in $(ls -l $DIR | grep -v total); do
	# update to LASTESTVERSION 
	LASTESTVERSION='mysql -s -N -e "select version from ecs.versionTable"'
	VERSION=$(echo $i | cut -c1-3 | sed 's/[^0-9]*//g')
	# db version greater equal 
	if [ "$LASTESTVERSION" -ge "$VERSION" ]; then
		echo "the script $i does not work"
	else
		# the following command will upgrade tables
		echo "the script $i is work"
		mysql < ${DIR}/${i}
		echo "$SUCCESSFULLY UPDATED"
		# the following update will "update" the db version 
		mysql -e "update ecs.versionTable SET version='$VERSION' where version ='$LASTESTVERSION'"
		echo "New version updated successfully. Current version is: $VERSION"
	fi
done

----------------------------------------------------------------------------------------------------------------------------
EX.3

$ DIR
043.createtable.sql
045.createtable.sql
048.createtable.sql
053.createtable.sql
055.createtable.sql
059.createtable.sql
061.createtable.sql
064.createtable.sql