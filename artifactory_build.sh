#!/bin/bash

USRNAME=`grep username artifactory.properties|awk -F"=" '{print $2}'`
PASSWD=`grep password artifactory.properties|awk -F"=" '{print $2}'`
APP=`grep app_name artifactory.properties|awk -F"=" '{print $2}'`
MODULE=`grep module_name artifactory.properties|awk -F"=" '{print $2}'`
PROJECT=`grep application_name artifactory.properties|awk -F"=" '{print $2}'`
SERVER=`grep server_name artifactory.properties|awk -F"=" '{print $2}'`
PORT=`grep port_number artifactory.properties|awk -F"=" '{print $2}'`
FILE_LOCATION=`grep file_path artifactory.properties|awk -F"=" '{print $2}'`


if [ $# -eq 1 ]
then
       echo "curl -i -u ${USRNAME}:${PASSWD} -X PUT "http://${SERVER}:${PORT}/artifactory/${PROJECT}/${APP}/${1}/${MODULE}" -T ${FILE_LOCATION}"

        if [ $? -eq 0 ]
        then
                echo "Upload is successful.You can see the uploaded artifact in http://${SERVER}:${PORT}/artifactory/${PROJECT}/${APP}/${1}/"
        else
                echo "Upload is not successful. Please upload the file again"
	exit 1
        fi
else
        echo "Please pass argument: <build_number>"
fi 
