#!/usr/bin/env bash

workDir=$(cd $(dirname $0); pwd)
cd ${workDir}/..

# $1 = 环境，eg：1、2...
# $2 = 应用

envNum=$1
appNameKey=$2
depName=""

if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjk8sdel.sh 5 meijian-site | someAll | someShare"
    exit 0
fi

getDeploymentName() {
    echo "-------- start delete deployment test${envNum} ${appNameKey} -------- "

    if [[ ${appNameKey} == "" ]]; then
        depName=$(kubectl get deployment -n meijian-test${envNum} | awk '{print $1}')
    else
        depName=$(kubectl get deployment -n meijian-test${envNum} | grep ${appNameKey} | awk '{print $1}')
    fi

    if [[ ${depName} == "" ]]; then
        echo "[error] 没有你要找的 deployment; env=${envNum} app=${appNameKey}"
        exit 0
    fi

    depArray=(${depName// /})
    if [[ ${#depArray[@]} > 0 ]]; then
        for(( i=0;i<${#depArray[@]};i++)) do
            echo "$i: ${depArray[i]}";
        done;

        read -p "请输入你要删除的 deployment 下标，并回车继续。" choose
        depName=${depArray[${choose}]}
    fi
}

deleteSomeOne() {
    getDeploymentName

    echo "-------- the deployment is ${depName} -------- "

    kubectl delete deployment ${depName} -n meijian-test${envNum}
}

deleteSomeAll() {
    someAll=(meijian-task2 share elink official-website meijian-activity-app meijian-cps-job meijian-cps-order-sync-job meijian-image-manage-job meijian-push-service-provider meijian-ugc-app)
    echo "总计 ${#someAll[@]} 个不需要启动的服务"
    for (( i = 0; i < ${#someAll[@]}; ++i )); do
        kubectl delete deployment ${someAll[${i}]} -n meijian-test${envNum}
    done
}

deleteSomeShare() {
    someAll=(meijian-channel-provider meijian-image-manage-service-provider meijian-defense-provider meijian-pbd-service-provider)
    echo "总计 ${#someAll[@]} 个共用的服务"
    if [[ ${envNum} == "1" ]]; then
        echo "[error] 共用服务部署在t1，所有不可删除t1的；eg：mjk8sdel.sh 2 someShare"
        exit 0
    fi
    for (( i = 0; i < ${#someAll[@]}; ++i )); do
        kubectl delete deployment ${someAll[${i}]} -n meijian-test${envNum}
    done
}

case ${appNameKey} in
someAll) deleteSomeAll ;;
someShare) deleteSomeShare ;;
*) deleteSomeOne ;;
esac
