#!/bin/bash

/start-mysql.sh

$HIVE_HOME/bin/hiveserver2 --hiveconf hive.root.logger=INFO,console
