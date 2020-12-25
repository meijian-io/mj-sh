#!/usr/bin/env bash

cd $(dirname $0)/..

# $1 = 环境，eg：1、2...

envNum=$1
logPath=./logs.mjk8s.connect.log
confAndN="-n meijian-test${envNum}"

if [[ $1 == "showTips" ]]; then
    echo "tips---->>"
    echo "  mjk8s.connect.sh 5  #连接指定测试环境K8S集群"
    echo "  连接日志查看下面的文件"
    echo "  tail -fn 10 ~/.mj-sh/logs.mjk8s.connect.log"
    exit 0
fi

if [[ ${envNum} == "" ]]; then
  echo "[error] input test env number，eg： mjk8s.connect.sh 5"
  exit 0
#elif [ ${envNum} == "pre" ]; then
#  confAndN="--kubeconfig $(cd ~ pwd)/.kube/config-pre.kubeconfig -n meijian-prerelease1"
fi

echo "-------- start connect test${envNum} -------- "
startConnect() {
  echo "--- start port-forward ${connectApp} ${appPort} ---"
  pidinfo=$(ps -ef | grep ${connectApp} | grep -v grep)
  if [ -n "${pidinfo}" ]; then
    echo "之前链接信息：${pidinfo}"
    pid=$(echo ${pidinfo} | awk '{print $2}')
    kill ${pid}
    sleep 3
  fi
  nohup kubectl port-forward ${connectApp} ${appPort}:${appPort} ${confAndN} >>$logPath &
}

declare -A dicApp
dicApp=(["6379"]="svc/redis-master" ["3306"]="svc/mysql" ["27017"]="svc/mongodb" ["61616"]="svc/activemq")

##打印指定key的value
#echo ${dicApp["6379"]}
##打印所有key值
#echo ${!dicApp[*]}
##打印所有value
#echo ${dicApp[*]}

#遍历key值
for key in $(echo ${!dicApp[*]}); do
  appPort=${key}
  connectApp=${dicApp[${key}]}
  startConnect
done

ktctlInfo=$(ps -ef | grep ktctl | grep -v grep)
if [ -n "${ktctlInfo}" ]; then
  echo "之前的ktctl链接：${ktctlInfo}"
  echo ${ktctlInfo} | awk '{print $2}' | xargs kill
  sleep 3
fi
nohup ktctl ${confAndN} connect --method=vpn >>$logPath &
tail -fn 10 ${logPath}
