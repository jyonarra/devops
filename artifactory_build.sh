#!/bin/bash

USRNAME=`grep username  AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
PASSWD=`grep password  AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
APP=`grep app_name AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
MODULE=`grep module_name AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
PROJECT=`grep application_name AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
SERVER=`grep server_name AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`
PORT=`grep port_number AppA_AppA.ear_artifactory.properties|awk -F"=" '{print $2}'`

#echo "artifactory is $NAME"
#echo "$APP" > ${1}_name_artifactory.txt
#echo "$MODULE" > ${1}_module_artifactory.txt

if [ $# -eq 4 ]
then
       echo "curl -i -u ${USRNAME}:${PASSWD} -X PUT "http://${SERVER}:${PORT}/artifactory/${PROJECT}/${APP}/${1}/${MODULE}" -T ${FILE_PATH}/${MODULE}"

        if [ $? -eq 0 ]
        then
                echo "Upload is successful.You can see the uploaded artifact in http://${SERVER}:${PORT}/artifactory/${PROJECT}/${APP}/${1}/"
        else
                echo "Upload is not successful. Please upload the file again"
	exit 1
        fi
else
        echo "Please pass 4 arguments : <app_name> <module_name> <build_number> <file_path>"
fi 
