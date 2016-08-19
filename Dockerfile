FROM centos:7

RUN useradd mysql
RUN yum install java-1.8.0-openjdk mariadb-server which -y

ENV HIVE_HOME=/usr/share/apache-hive-1.1.1-bin
ENV HADOOP_HOME=/usr/share/hadoop-2.6.4
ENV JAVA_HOME=/usr
ENV HADOOP_USER_CLASSPATH_FIRST=true

RUN curl http://apache.claz.org/hive/hive-1.1.1/apache-hive-1.1.1-bin.tar.gz -s | tar -xz -C /usr/share/ \
 && curl http://apache.claz.org/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz -s | tar -xz -C /usr/share/ \
 && curl https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/1.4.6/mariadb-java-client-1.4.6.jar -s -o $HIVE_HOME/lib/mariadb-connector-java.jar

ADD hive-site.xml $HIVE_HOME/conf/
ADD bootstrap-mysql.sh /

RUN chmod +x /bootstrap-mysql.sh && /bootstrap-mysql.sh

EXPOSE 10000

CMD ["$HIVE_HOME/bin/hiveserver2", "--hiveconf", "hive.root.logger=INFO,console"]
