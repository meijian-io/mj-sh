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

if [[ $2 == "all" ]]; then
    echo "重启t$1所有服务"
    ssh root@test$1 "/opt/script/all-restart.sh"
    exit 0
fi

action=restart
if [[ $3 != "" ]]; then
        action=$3
fi

services=()
if ssh root@test$1 "[ -d /opt/mj-app/$2 ]"; then
    services[${#services[@]}]=$2
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2 ]"; then
    services[${#services[@]}]="meijian-$2"
fi

if ssh root@test$1 "[ -d /opt/mj-app/mj-$2 ]"; then
    services[${#services[@]}]="mj-$2"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-app ]"; then
    services[${#services[@]}]="meijian-$2-app"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-server ]"; then
    services[${#services[@]}]="meijian-$2-server"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-provider ]"; then
    services[${#services[@]}]="meijian-$2-provider"
fi

if ssh root@test$1 "[ -d /opt/mj-app/meijian-$2-service-provider ]"; then
    services[${#services[@]}]="meijian-$2-service-provider"
fi

length=${#services[*]}
if [[ $length -eq 0 ]]; then
    echo "无此服务"
    exit 0
elif [[ $length -eq 1 ]]; then
        service=${services[0]}
else
    for(( i=0;i<${#services[@]};i++)) do
    echo "$i | ${services[i]}";
    done;
    read -p "select target service number:" service_number
    service=${services[$service_number]}
fi

scrip_file="/opt/script/restart.sh"
rpc=(meijian-mall-service-provider meijian-data-change-manage-provider  meijian-pbd-service-provider meijian-promotion-service-provider meijian-push-service-provider meijian-image-manage-service-provider)
for x in ${rpc[@]};do
    if [ $service = $x ]
    then
	    scrip_file="/opt/script/restart-mall.sh"
    fi
done

script="$scrip_file $service $action"

echo "准备执行:$script"
ssh root@test$1 "$script"


