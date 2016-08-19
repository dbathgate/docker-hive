FROM centos:7

ENV HIVE_HOME=/usr/share/apache-hive-1.1.1-bin
ENV HADOOP_HOME=/usr/share/hadoop-2.6.4
ENV JAVA_HOME=/usr
ENV HADOOP_USER_CLASSPATH_FIRST=true

RUN useradd mysql \
 && useradd hive \
 && yum install java-1.8.0-openjdk mariadb-server which -y \
 && curl https://www.apache.org/dist/hive/hive-1.1.1/apache-hive-1.1.1-bin.tar.gz -s | tar -xz -C /usr/share/ \
 && curl https://www.apache.org/dist/hadoop/core/hadoop-2.6.4/hadoop-2.6.4.tar.gz -s | tar -xz -C /usr/share/ \
 && curl https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/1.4.6/mariadb-java-client-1.4.6.jar -s -o $HIVE_HOME/lib/mariadb-connector-java.jar

ADD hive-site.xml $HIVE_HOME/conf/
ADD start-hive.sh /
ADD start-mysql.sh /

RUN chmod +x /start-hive.sh \
 && chmod +x /start-mysql.sh \
 && mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/ \
 && /start-mysql.sh \
 && mysql -u root <<< "CREATE DATABASE metastore;" \
 && cd $HIVE_HOME/scripts/metastore/upgrade/mysql/; mysql -u root metastore < hive-schema-1.1.0.mysql.sql \
 && mysql -u root <<< "CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword'; " \
 && mysql -u root <<< "GRANT all on *.* to 'hiveuser'@localhost identified by 'hivepassword';" \
 && mysql -u root <<< "flush privileges;" \
 && $HADOOP_HOME/bin/hadoop fs -mkdir /tmp/hive \
 && $HADOOP_HOME/bin/hadoop fs -chown hive:hive /tmp/hive \
 && $HADOOP_HOME/bin/hadoop fs -chmod +w /tmp/hive 

EXPOSE 10000

CMD ["/start-hive.sh"]
