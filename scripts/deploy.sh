#!/bin/bash
REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=dongwon-springboot2-webservice

echo "> Copy build files."

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Check current operating application."

CURRENT_PID=$(pgrep -fl dongwon-springboot2-webservice | grep jar | awk '{print $1}')

echo "Current operating application's PID: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> Application doesn't exist."
else
  echo "> Kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
    sleep 5
fi

echo "> Deploy new application."

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> Jar name: $JAR_NAME."

echo "> Give execution permission to $JAR_NAME."

chmod +x $JAR_NAME

echo "> Execute $JAR_NAME."

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
