#!/bin/bash

ARTIFACTORY_NAME=`grep artifactory_name artifactory.properties|awk -F"=" '{print $2}'`
echo "Artifactory is $ARTIFACTORY_NAME"

if [ $# -eq 1 ]
then
if [ ${ARTIFACTORY_NAME} == "JFROG" ]
then
    USRNAME=`grep ${ARTIFACTORY_NAME}_username artifactory.properties|awk -F"=" '{print $2}'`
    PASSWD=`grep ${ARTIFACTORY_NAME}_password artifactory.properties|awk -F"=" '{print $2}'`
    APP=`grep ${ARTIFACTORY_NAME}_app_name artifactory.properties|awk -F"=" '{print $2}'`
    MODULE=`grep ${ARTIFACTORY_NAME}_module_name artifactory.properties|awk -F"=" '{print $2}'`
    PROJECT=`grep ${ARTIFACTORY_NAME}_application_name artifactory.properties|awk -F"=" '{print $2}'`
    SERVER=`grep ${ARTIFACTORY_NAME}_server_name artifactory.properties|awk -F"=" '{print $2}'`
    PORT=`grep ${ARTIFACTORY_NAME}_port_number artifactory.properties|awk -F"=" '{print $2}'`

cd /sprint/stage
curl -u${USRNAME}:${PASSWD} -O http://${SERVER}:${PORT}/artifactory/generic-local/${APP}/${1}/${MODULE}
if [ $? -eq 0 ]
        then
                echo "Download is successful."
        else
                echo "Download is not successful."
        exit 1
        fi
fi

if [ ${ARTIFACTORY_NAME} == "NEXUS" ]
then
    USRNAME=`grep ${ARTIFACTORY_NAME}_username artifactory.properties|awk -F"=" '{print $2}'`
    PASSWD=`grep ${ARTIFACTORY_NAME}_password artifactory.properties|awk -F"=" '{print $2}'`
    APP=`grep ${ARTIFACTORY_NAME}_app_name artifactory.properties|awk -F"=" '{print $2}'`
    MODULE=`grep ${ARTIFACTORY_NAME}_module_name artifactory.properties|awk -F"=" '{print $2}'`
    PROJECT=`grep ${ARTIFACTORY_NAME}_application_name artifactory.properties|awk -F"=" '{print $2}'`
    SERVER=`grep ${ARTIFACTORY_NAME}_server_name artifactory.properties|awk -F"=" '{print $2}'`
    PORT=`grep ${ARTIFACTORY_NAME}_port_number artifactory.properties|awk -F"=" '{print $2}'`

cd /sprint/stage
  curl -u ${USRNAME}:${PASSWD} -O http://${SERVER}:${PORT}/repository/sprint_applications/${APP}/${1}/${MODULE}
      if [ $? -eq 0 ]
        then
                echo "Download is successful."
        else
                echo "Download is not successful."
        exit 1
        fi
        fi
else
        echo "Please pass argument: <build_number>"
fi
