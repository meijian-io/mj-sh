#!/bin/sh

if [[ $1 == "" ]]; then
        #statements
        echo "input test env number"
        exit 0
fi

if [[ $2 == "" ]]; then
        #statements
        echo "input service name"
        exit 0
fi
line=500
if [[ $3 != "" ]]; then
        line=$3
fi

logFiles=()
if ssh root@test$1 "[ -d /opt/mj-app/$2 ]"; then
    logFiles[${#logFiles[@]}]=$2
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2 ]"; then
    logFiles[${#logFiles[@]}]="meijian-$2"
fi

if ssh root@test$1 "[ -d /opt/mj-app/mj-$2 ]"; then
    logFiles[${#logFiles[@]}]="mj-$2"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-app ]"; then
    logFiles[${#logFiles[@]}]="meijian-$2-app"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-server ]"; then
    logFiles[${#logFiles[@]}]="meijian-$2-server"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-provider ]"; then
    logFiles[${#logFiles[@]}]="meijian-$2-provider"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-service-provider ]"; then
    logFiles[${#logFiles[@]}]="meijian-$2-service-provider"
fi

length=${#logFiles[*]}
if [[ $length -eq 1 ]]; then
        logFile=${logFiles[0]}
else
    for(( i=0;i<${#logFiles[@]};i++)) do
    echo "$i | ${logFiles[i]}";
    done;
    read -p "select target service number:" service_number
    logFile=${logFiles[$service_number]}
fi

script="tail -fn $line \"/opt/mj-app/$logFile/log/$logFile.log\""
ssh root@test$1 "$script"


