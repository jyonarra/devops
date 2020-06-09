#!/bin/bash

echo "PLEASE TYPE THE JAVA VERSION NEEDED TO COMPILE THE CODE e.g 1.7 1.8 1.6"
read java_name
if [ "${java_name}" = "1.8" ]
  then
      echo "WE ARE PULLING THE CODEBASE IN LOCAL"
   else
      echo "THIS JAVA VERSION IS NOT SUPPORTED FOR COMPILATION"
fi

echo "CHECKING OUT SOURCE CODE FROM GIT REPOSITORY"
git clone https://github.com/jyonarra/devops.git

echo "CHECKOUT DONE"
