#!/usr/bin/env bash

workDir=$(cd $(dirname $0); pwd)
cd ${workDir}/..

# $1 = 应用
# $2 = 环境，eg：1、2...

envNum=$1
appNameKey=$2
podName=""

if [[ ${appNameKey} == "" ]]; then
    echo "[error] input app name，eg：( mjk8sdebug.sh 5 meijian-site )"
    exit 0
fi
if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjk8sdebug.sh 5 meijian-site"
    exit 0
fi

echo "-------- start debug test${envNum} ${appNameKey} -------- "

getPodName() {
    podName=$(kubectl get pod -n meijian-test${envNum} | grep ${appNameKey} | awk '{print $1}')
}
getPodName

if [[ ${podName} == "" ]]; then
    echo "[error] 没有你要找的容器组; env=${envNum} app=${appNameKey}"
    exit 0
fi

podArray=(${podName// /})
if [[ ${#podArray[@]} > 1 ]]; then
    for(( i=0;i<${#podArray[@]};i++)) do
        echo "$i: ${podArray[i]}";
    done;

    read -p "请输入你要进入的pod下标，并回车继续。" choose
    podName=${podArray[${choose}]}
fi

echo "-------- the pod is ${podName} -------- "

appFullName=${podName%-*}
appFullName=${appFullName%-*}

# 系统端口  $serverPort  $debugPort
source ./opt/script/port.sh ${appFullName}

kubectl port-forward ${podName} ${debugPort}:9090 -n meijian-test${envNum}
