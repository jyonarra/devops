#!/bin/bash

if [ -z "$1" ]; then

echo ""

echo "Please provide application properties file as an argument"

echo ""

echo -e 'syntax: \033[1;33m sh sonar.sh <<sonar properties file>> \033[0m'

echo ""

echo -e 'example---> \033[1;31m sh sonar.sh app1.properties \033[0m'  

echo ""
exit 1
fi

#=======================================================================================
#exporting path for sonar scanner

#export PATH="$PATH:/sprint/sonar/sonar-runner/sonar-scanner-4.3.0.2102/bin"

#=======================================================================================
#Application sonar properties file

input="$1"

echo "Application properties file="$input

#=======================================================================================

s=" -X"

PROJECTKEY=`grep projectKey $input|awk -F"=" '{print $2}'`
if [ -z "$PROJECTKEY" ]
then
      echo "PROJECTKEY shouldn't be NULL"
      exit 1
else
      s+=" -Dsonar.projectKey=$PROJECTKEY"
fi

PROJECTNAME=`grep projectName $input|awk -F"=" '{print $2}'`
if [ -z "$PROJECTNAME" ]
then
      echo "PROJECTNAME is NULL"
      exit 1
else
      s+=" -Dsonar.projectName=$PROJECTNAME"
fi

VERSION=`grep projectVersion $input|awk -F"=" '{print $2}'`
if [ -z "$VERSION " ]
then
      echo "Version is NULL"
      exit 1
elif [ $VERSION == "0.0" ] 
then
      echo "Version not to be 0.0"
      exit 1
else
      s+=" -Dsonar.projectVersion=$VERSION"
fi

if [ -z "$SOURCEENCODING" ]
then
      echo "SourceEncoding is NULL"
      s+=" -Dsonar.sourceEncoding=UTF-8"
else
      s+=" -Dsonar.sourceEncoding=$SOURCEENCODING"
fi

LANGUAGE=`grep language $input|awk -F"=" '{print $2}'`
if [ -z "$LANGUAGE" ]
then
      echo "Language is NULL"
      s+=" $LANGUAGE"
else
      s+=" -Dsonar.language=$LANGUAGE"
fi

BINARIES=`grep binaries $input|awk -F"=" '{print $2}'`
if [ -z "$BINARIES" ]
then
      echo "Binaries path is NULL"
      s+=" $BINARIES"
else
      s+=" -Dsonar.java.binaries=$BINARIES"
fi

SOURCES=`grep sources $input|awk -F"=" '{print $2}'`
if [ -z "$SOURCES" ]
then
      echo "Sources path is NULL"
      exit 1
else
      s+=" -Dsonar.sources=$SOURCES"
fi

BASEDIR=`grep basedir $input|awk -F"=" '{print $2}'`
if [ -z "$BASEDIR" ]
then
      echo "Basedir not set and path is NULL"
      exit 1
else
      s+=" -Dsonar.projectBaseDir=$BASEDIR"
fi

s+=" -Dsonar.host.url=http://161.202.18.153:9000"

echo $s

sonar-scanner $s

#$echo $sonar-scanner

#============================================================================================================================================================#Running sonar scanner

#sonar-scanner -X -Dsonar.projectKey=$PROJECTKEY -Dsonar.projectName=$PROJECTNAME -Dsonar.projectVersion=$VERSION -Dsonar.projectBaseDir=$BASEDIR -Dsonar.sou#rceEncoding=$SOURCEENCODING -Dsonar.java.binaries=$BINARIES -Dsonar.sources=$SOURCES -Dsonar.host.url=http://161.202.18.153:9000

#============================================================================================================================================================

#cp input sonar-project.properties

#sonar-scanner -Dproject.settings=sonar-project.properties

#cp /tmp/input1.txt /sonar-project.properties
