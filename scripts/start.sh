#!/bin/bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app/step3
PROJECT_NAME=dongwon-springboot2-webservice

echo "> Copy build files."

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Deploy new application."

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> Jar name: $JAR_NAME."

echo "> Give execution permission to $JAR_NAME."

chmod +x $JAR_NAME

echo "> Execute $JAR_NAME."

IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/application-"$IDLE_PROFILE".properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
    -Dspring.profiles.active=$IDLE_PROFILE \
    "$JAR_NAME" > $REPOSITORY/nohup.out 2>&1 &