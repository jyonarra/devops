#!/bin/bash

APP=`grep app_name artifactory.properties|awk -F"=" '{print $2}'`
MODULE=`grep module_name artifactory.properties|awk -F"=" '{print $2}'`
SERVER=`grep server_name artifactory.properties|awk -F"=" '{print $2}'`
PORT=`grep port_number artifactory.properties|awk -F"=" '{print $2}'`

if [ $# -eq 1 ]
then
cd /sprint/stage
wget http://${SERVER}:${PORT}/artifactory/generic-local/${APP}/${1}/${MODULE}
if [ $? -eq 0 ]
        then
                echo "Download is successful."
        else
                echo "Download is not successful."
	exit 1
        fi
else
        echo "Please pass argument: <build_number>"
fi 
