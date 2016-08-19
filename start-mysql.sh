#!/bin/bash

su - mysql -c "nohup /usr/libexec/mysqld </dev/null >/dev/null 2>&1 & echo $! > /var/lib/mysql/mysql.pid"
/usr/libexec/mariadb-wait-ready `cat /var/lib/mysql/mysql.pid`
