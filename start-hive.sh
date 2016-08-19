#!/bin/bash

/start-mysql.sh

su hive -c "$HIVE_HOME/bin/hiveserver2 --hiveconf hive.root.logger=INFO,console"
