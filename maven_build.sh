#Shell Script for MAVEN BUILD
#!/bin/sh
. ./maven.properties
#JAVA_HOME
java_home=$(cat $1 | grep JAVA_HOME)
echo $java_home
export $java_home

#MAVEN_HOME
m2_home=$(cat $1 | grep MAVEN_HOME | cut -d= -f2)
echo $m2_home
export M2_HOME=$m2_home

#COMMAND FOR BUILD
commad=$(cat ./maven.properties | grep COMMAND |  cut -d= -f2)
echo $commad
settings_file=$(cat ./maven.properties | grep settings_file |  cut -d= -f2)
echo "settings_file $settings_file"
skipTests=$(cat ./maven.properties | grep skipTests |  cut -d= -f2)
echo "skipTests $skipTests"
settings_PATH=$(cat ./maven.properties | grep settings_PATH |  cut -d= -f2)
echo "settings_PATH $settings_PATH"
code_PATH=$(cat ./maven.properties | grep code_PATH |  cut -d= -f2)
echo "code_PATH $code_PATH"
cd $code_PATH
if [ $commad == "install"  ] && [  $settings_file == YES ]  &&  [ $skipTests == YES  ]
then
$m2_home/bin/mvn clean install --skipTests -s $settings_PATH/settings.xml
elif [ $commad == "install"  ] && [  $settings_file == NO ]  &&  [ $skipTests == YES  ] 
then
$m2_home/bin/mvn clean install --skipTests 
elif [ $commad == "install"  ] && [  $settings_file == NO ]  &&  [ $skipTests == NO  ]
then
 $m2_home/bin/mvn clean install 
elif [ $commad == "install"  ] && [  $settings_file == YES ]  &&  [ $skipTests == NO ]
then
$m2_home/bin/mvn clean install  -s $settings_PATH/settings.xml
fi
