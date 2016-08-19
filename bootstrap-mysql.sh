#!/bin/bash

mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/
su - mysql -c "nohup /usr/libexec/mysqld 2>&1 > /dev/null & echo $! > /var/lib/mysql/mysql.pid"
sleep 2

/usr/libexec/mariadb-wait-ready `cat /var/lib/mysql/mysql.pid`

mysql -u root <<< "CREATE DATABASE metastore;"
cd $HIVE_HOME/scripts/metastore/upgrade/mysql/; mysql -u root metastore < hive-schema-1.1.0.mysql.sql

mysql -u root <<< "CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword'; "
mysql -u root <<< "GRANT all on *.* to 'hiveuser'@localhost identified by 'hivepassword';"
mysql -u root <<< "flush privileges;
