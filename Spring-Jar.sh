
#!/bin/bash

#SPRING JAR V 1.0 
#SPRING JAR QUICKLY BUILDS AND RUNS SPRING PROJECTS
# bash Spring-Jar.sh myMavenModuleFolder myOtherMavenModuleFolder


if [ "$#" -eq 0 ]; then
  echo "ERROR: no args provided"
  exit 1
fi  


#gets path of directory youre in currently
WORKING_DIR=$(pwd)

for MODULE_FOLDER in "$@"; do 
  if [ ! -d "$MODULE_FOLDER" ]; then
    echo "No directory found for $MODULE_FOLDER in $WORKING_DIR"
    exit 1
  fi 

  cd $MODULE_FOLDER || { echo "failed to cd into $MODULE_FOLDER"; exit 1; }

  if [ -f "pom.xml" ]; then
    echo "maven detected. building jar for $MODULE_FOLDER"
    mvn clean package -DskipTests || { echo "failed to generate jar"; exit 1; } 
    JAR_FILE=$(find target -type f -name "*jar" | grep -v original | head -n 1)
  elif [ -f "build.gradle" ]; then 
    echo "gradle detected. building jar for $MODULE_FOLDER"
    ./gradlew clean build -x test || { echo "gradle build failed"; exit 1; }
    JAR_FILE=$(find target -type f -name "*jar" | grep -v original | head -n 1)
  else 
    echo "no maven or gradle build found in $MODULE_FOLDER"
    exit 1
  fi 

  if [ ! $JAR_FILE ]; then 
    echo "no jar file found"
    exit 1
  fi 

  echo "running jar: $JAR_FILE"
  java -jar $JAR_FILE
done







