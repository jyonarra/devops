#Shell Script for MAVEN BUILD
#!/bin/sh

#importing property file
. ./maven.properties

echo $BUILD_TOOL

if [ $BUILD_TOOL == "MAVEN" ]
then

#JAVA_HOME
echo "JAVA_HOME is $JAVA_HOME"
export JAVA_HOME=$JAVA_HOME


#MAVEN_HOME
echo "MAVEN_HOME is  $MAVEN_HOME"
export M2_HOME=$MAVEN_HOME

#COMMAND FOR BUILD
echo "build command $GOALS"


#Settings.file is there or not
echo "settings_file $settings_file"

#SkipTests
echo "Skiptest $skipTests"

#Settings.xml file PATH if they have specific
echo "settings_PATH $settings_PATH"

#code path for build
echo "code_PATH $code_PATH"
cd $code_PATH

#build the code based on goal and settings.xml file and inlcuding skipTests 
if [  $settings_file == YES ]  &&  [ [ $skipTests == YES  ] || [ $skipTests == Yes ] ||  [ $skipTests == yes ] ]
then
$MAVEN_HOME/bin/mvn clean $GOALS -DskipTests -s $settings_PATH/settings.xml
elif [  $settings_file == NO ]  &&  [ $skipTests == YES  ] 
then
$MAVEN_HOME/bin/mvn clean $GOALS -DskipTests 
elif [  $settings_file == NO ]  &&  [ $skipTests == NO  ]
then
 $MAVEN_HOME/bin/mvn clean $GOALS
elif [  $settings_file == YES ]  &&  [ $skipTests == NO ]
then
$MAVEN_HOME/bin/mvn clean $GOALS  -s $settings_PATH/settings.xml
fi

else 

#JAVA_HOME
echo "JAVA_HOME is $JAVA_HOME"
export JAVA_HOME=$JAVA_HOME

#code path for build
echo "code_PATH $code_PATH"
cd $code_PATH
echo "entering to do ant build $BUILD_TOOL"
$ANT_HOME/ant -f build.xml

fi
