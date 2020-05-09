#!/usr/bin/env bash

workDir=$(cd $(dirname $0); pwd)
cd ${workDir}/..

# $1 = 应用
# $2 = 环境，eg：1、2...

appName=$1
envNum=$2
podName=""

if [[ ${appName} == "" ]]; then
    echo "[error] input app name，eg：( ./mjk8sdebug.sh meijian-site 5 )"
    exit 0
fi
if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： ./mjk8sdebug.sh meijian-site 5"
    exit 0
fi

echo "-------- start debug test${envNum} ${appName} -------- "

getPodName() {
    podName=$(kubectl get pod -n meijian-test${envNum} | grep ${appName} | awk '{print $1}')
}
getPodName

if [[ ${podName} == "" ]]; then
    echo "[error] podName is undefined; env=${envNum} app=${appName}"
    exit 0
fi

echo "-------- the pod is ${podName} -------- "

# 系统端口  $serverPort  $debugPort
source ./opt/script/port.sh

kubectl port-forward ${podName} ${debugPort}:9090 -n meijian-test${envNum}
