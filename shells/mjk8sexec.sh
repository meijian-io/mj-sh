#!/usr/bin/env bash

# $1 = 环境，eg：1、2...
# $2 = 应用

envNum=$1
appNameKey=$2
podName=""

if [[ ${envNum} == "" ]]; then
    echo "[error] 请输入测试环境编号，eg： mjk8sexec.sh 5 site"
    exit 0
fi

echo "-------- ready to exec test${envNum} ${appNameKey} -------- "

getPodName() {
    if [[ ${appNameKey} == "" ]]; then
        podName=$(kubectl get pod -n meijian-test${envNum} | awk '{print $1}')
    else
        podName=$(kubectl get pod -n meijian-test${envNum} | grep ${appNameKey} | awk '{print $1}')
    fi

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
}
getPodName

echo "-------- the pod is ${podName} -------- "
sleep 1s

kubectl exec -it ${podName} -n meijian-test${envNum} -- sh
