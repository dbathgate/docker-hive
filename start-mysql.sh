#!/bin/bash

su - mysql -c "nohup /usr/libexec/mysqld 2>&1 > /dev/null & echo $! > /var/lib/mysql/mysql.pid"
sleep 2
/usr/libexec/mariadb-wait-ready `cat /var/lib/mysql/mysql.pid`
