#!/bin/bash

if [ $# -eq 1 ]
then
        echo "App name is $1"
else
        echo "Please pass the app name"
        exit 1
fi

Module_name=$1
Git_URL=https://github.com/jyothin212/devops.git

git clone ${Git_URL}

cd devops
rm -rf *
sleep 1
git checkout -b ${Module_name}
sleep 1
cp /sprint/jenkins/clone_utility/${Module_name}/*.properties .
sleep 1
git add --all
sleep 1
git commit -m "Creating $1 branch and checkin properties files in Git"
sleep 2
git push --set-upstream https://047f973c21ca09ffff95d202b3fde8551af886dd:x-oauth-basic@github.com/jyothin212/devops.git ${Module_name}
sleep 3
