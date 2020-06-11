#!/bin/bash

if [ $# -eq 1 ]
then
java -jar jenkins-cli.jar -s http://161.202.18.153:8080/jenkins/ -auth admin:118013e82c285329f4f47160dc3a396350 create-job $1 < config.xml
else
        echo " Please pass the jenkins job name"
fi
