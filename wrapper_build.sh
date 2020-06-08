#!/bin/bash

Build_num=$2

if [ $# -ne 2 ]
then
	echo "Please pass the application name and Build Number"
	echo "sh wrapper_build.sh app1 2"
	exit 1
fi

echo "Downloading the Devops related GIT files"
git clone -b $1 https://github.com/jyonarra/devops.git

#cd Devops

#echo "Triggering the Build checkout"
#sh abhsiehk_script.sh
git clone https://github.com/jyonarra/sample-poc.git
if [ $? -eq 0 ]
then
echo "Checkout completed under $pwd"
else
echo "Checkout failed under $pwd"
exit 1
fi

echo "Starting the Build"
sh maven_build.sh maven.properties ./sample-poc
if [ $? -eq 0 ]
then
echo "Build completed "
else
echo "Build failed "
exit 1
fi

echo "Uploading Artifacts"
sh artifactory_build.sh $Build_num 
if [ $? -eq 0 ]
then
echo "Artfact upload completed"
else
echo "Artifact upload failed"
exit 1
fi

echo "Performing Sonar Analaysis"
sh sonar.sh
if [ $? -eq 0 ]
then
echo "Sonar completed under $pwd"
else
echo "Sonar failed under $pwd"
exit 1
fi
sleep 2

