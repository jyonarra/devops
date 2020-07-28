#!/bin/bash
#. ./appserver.properties

if [ -z $1 ]; then
    echo -e  "The deployment script needs environment as first parameter, provide selected environment name."
    echo -e  "Example: ./deploy-app.sh DEV1"
    exit 1
fi

ENVIRONMENT=$1
EXIST=`echo "app_"${ENVIRONMENT}"_exist"`
ENV_EXIST=`grep ${EXIST} appserver.properties|awk -F"=" '{print $2}'`
HOSTNAME=`echo "app_"${ENVIRONMENT}"_hostname"`
ENV_HOSTNAME=`grep ${HOSTNAME} appserver.properties|awk -F"=" '{print $2}'`
USER=`echo "app_"${ENVIRONMENT}"_user"`
ENV_USER=`grep ${USER} appserver.properties|awk -F"=" '{print $2}'`
DEPLOY=`echo "app_"${ENVIRONMENT}"_deploy"`
ENV_DEPLOY=`grep ${DEPLOY} appserver.properties|awk -F"=" '{print $2}'`
BACKUP=`echo "app_"${ENVIRONMENT}"_backup"`
ENV_BACKUP=`grep ${BACKUP} appserver.properties|awk -F"=" '{print $2}'`
SERVER_TYPE=`echo "app_"${ENVIRONMENT}"_server_type"`
ENV_SERVER_TYPE=`grep ${SERVER_TYPE} appserver.properties|awk -F"=" '{print $2}'`
AUTO_DEPLOY=`echo "app_"${ENVIRONMENT}"_deploy"`
ENV_AUTO_DEPLOY=`grep ${AUTO_DEPLOY} appserver.properties|awk -F"=" '{print $2}'`
INSTANCE=`echo "app_"${ENVIRONMENT}"_instance"`
ENV_INSTANCE=`grep ${INSTANCE} appserver.properties|awk -F"=" '{print $2}'`
START=`echo "app_"${ENVIRONMENT}"_start"`
ENV_START=`grep ${START} appserver.properties|awk -F"=" '{print $2}'`
STOP=`echo "app_"${ENVIRONMENT}"_stop"`
ENV_STOP=`grep ${STOP} appserver.properties|awk -F"=" '{print $2}'`
ARTIFACT=`grep app_artifact_name appserver.properties|awk -F"=" '{print $2}'`
APP=`grep app_name appserver.properties|awk -F"=" '{print $2}'`
MODULE=`grep app_module_name appserver.properties|awk -F"=" '{print $2}'`
STAGE=`grep app_stage appserver.properties|awk -F"=" '{print $2}'`

if [ ${ENV_EXIST} == "YES" ]
then
    echo "Taking backup of existing artifact file from deploy folder"
    echo
    DATE=`date +%y%m%d`

    ## backup the artifact
   sshpass -p "devopsadmin" ssh -q ${ENV_USER}@${ENV_HOSTNAME} "cd ${ENV_BACKUP} && cp ${ENV_DEPLOY}/${ARTIFACT} ${ARTIFACT}_${DATE}"
        if [ $? -eq 0 ]
    then
        echo "${ARTIFACT} is backed up at ${ENV_BACKUP}/${ARTIFACT}_${DATE}"
        echo
    else
        echo "Backup of ${ARTIFACT} failed, check errors.."
        exit 1
    fi

        ##deploy the artifact
    echo "Copying the ${ARTIFACT} to ${ENV_HOSTNAME}:${ENV_DEPLOY}"
    echo
#    cd /sprint/stage
     cd ${STAGE}
    if [ -f ${STAGE}/${ARTIFACT} ]
    then

        sshpass -p "devopsadmin" scp ${ARTIFACT} ${ENV_USER}@${ENV_HOSTNAME}:${ENV_DEPLOY}
    else
        echo "File ${ARTIFACT} does not exist, check errors.."
        exit 1
    fi
    if [ $? -eq 0 ]
    then
        echo "${ARTIFACT} is copied at ${ENV_DEPLOY}/${ARTIFACT}"
        echo
    else
        echo "Copy of ${ARTIFACT} failed, check errors.."
        exit 1
    fi
    if [ ${ENV_SERVER_TYPE} == "jboss" ]
    then
        ##restart server
        if [ ${ENV_AUTO_DEPLOY} == "YES" ]
        then
            ##stop server
           sshpass -p "devopsadmin" ssh -q ${ENV_USER}@${ENV_HOSTNAME} "sh ${ENV_STOP}"
            if [ $? -eq 0 ]
            then
                echo "Stopped app server successfully on ${ENV_HOSTNAME}"
                echo
            else
                echo "Stop app server on ${ENV_HOSTNAME} failed, check errors.."
                exit 1
            fi
            ##start server
            sshpass -p "devopsadmin" ssh -q ${ENV_USER}@${ENV_HOSTNAME} "sh ${ENV_START}"
            if [ $? -eq 0 ]
            then
                echo "Started app server successfully on ${ENV_HOSTNAME}"
                echo
            else
                echo "Start app server on ${ENV_HOSTNAME} failed, check errors.."
                exit 1
            fi
        else
            ##undeploy app
            sshpass -p "devopsadmin" ssh -q ${ENV_USER}@${ENV_HOSTNAME} "cd ${ENV_INSTANCE} && ./jboss-cli.sh --connect controller=localhost:9990 --command='undeploy ${ARTIFACT}'"
            if [ $? -eq 0 ]
            then
                echo "Undeployed ${ARTIFACT} successfully on ${ENV_HOSTNAME}"
                echo
            else
                echo "Undeploy of ${ARTIFACT} on ${ENV_HOSTNAME} failed, check errors.."
                exit 1
            fi
            
            sleep 30
            
            ##deploy app
           sshpass -p "devopsadmin" ssh -q ${ENV_USER}@${ENV_HOSTNAME} "cd ${ENV_INSTANCE} && ./jboss-cli.sh --connect controller=localhost:9990 --command='deploy ${ENV_DEPLOY}/${ARTIFACT} --force'"
            if [ $? -eq 0 ]
            then
                echo "Deployed ${ARTIFACT} successfully on ${ENV_HOSTNAME}"
                echo
            else
                echo "Deploy of ${ARTIFACT} on ${ENV_HOSTNAME} failed, check errors.."
                exit 1
            fi
        fi
    fi

echo "************Deployment of ${app-artifact-name} completed to ${ENVIRONMENT} **********"
else
    echo "${ENVIRONMENT} configuration is not available for this app"
    exit 1
fi
