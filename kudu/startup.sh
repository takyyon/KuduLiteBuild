#!/bin/bash
if [ $# -ne 5 ]; then
	echo "Missing parameters; exiting"
	exit 1
fi

GROUP_ID=$1
GROUP_NAME=$2
USER_ID=$3
USER_NAME=$4
SITE_NAME=$5

groupadd -g $GROUP_ID $GROUP_NAME
useradd -u $USER_ID -g $GROUP_NAME $USER_NAME
chown -R $USER_NAME:$GROUP_NAME /tmp
mkdir -p /home/LogFiles/webssh

/bin/bash -c "benv node=9 npm=6 pm2 start /opt/webssh/index.js -o /home/LogFiles/webssh/pm2.log -e /home/LogFiles/webssh/pm2.err &"

export KUDU_RUN_USER="$USER_NAME"
export HOME=/home
export WEBSITE_SITE_NAME=$SITE_NAME
export APPSETTING_SCM_USE_LIBGIT2SHARP_REPOSITORY=0
export KUDU_APPPATH=/opt/Kudu
export APPDATA=/opt/Kudu/local


cd /opt/Kudu

echo $(date) running .net core
ASPNETCORE_URLS=http://0.0.0.0:8181 runuser -p -u "$USER_NAME" -- benv dotnet=2.2 dotnet Kudu.Services.Web.dll
