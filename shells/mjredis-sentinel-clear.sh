#!/bin/bash

envNum=$1   # 环境下标
pattern=$2  # 要删除的key 正则
dbNum=$3    # 哪个db，默认db=0
host=redis-master.meijian-test${envNum}.svc.cluster.local
port=6379
pwd=Mj@tjsaowu@rDp

if [[ $1 == "showTips" ]]; then
    echo "tips---->> mjredis-sentinel-clear.sh"
    echo "    mjredis-sentinel-clear.sh 6 \"*userId*\"          # 删除test6环境db=0匹配到的key"
    echo "    mjredis-sentinel-clear.sh 6 \"*userId*\" 2        # 删除test6环境db=2匹配到的key"
    exit 0
fi
if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjredis-sentinel-clear.sh 6 \"*userId*\""
    exit 0
fi
if [[ ${pattern} == "" ]]; then
  echo "请输入需要删除的key正则，eg：mjredis-sentinel-clear.sh 6 \"*userId*\" 10"
  exit 0
fi
if [[ ${dbNum} == "" ]]; then
  dbNum=0
fi

redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} --scan --pattern "${pattern}" 2>/dev/null |\
 xargs redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} del 2>/dev/null
#/opt/redis-3.0.7/src/redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} keys "$1" 2>/dev/null |\
# xargs /opt/redis-3.0.7/src/redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} del 2>/dev/null
#/opt/redis-3.0.7/src/redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} --scan --pattern "$1" 2>/dev/null |\
# xargs /opt/redis-3.0.7/src/redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} del  2>/dev/null
