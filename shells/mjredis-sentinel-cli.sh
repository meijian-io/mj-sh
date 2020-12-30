#!/bin/bash

envNum=$1   # 环境下标
dbNum=$2    # 哪个db，默认db=0
host=redis-master.meijian-test${envNum}.svc.cluster.local
port=6379
pwd=Mj@tjsaowu@rDp

if [[ $1 == "showTips" ]]; then
    echo "tips---->> mjredis-sentinel-cli.sh"
    echo "    mjredis-sentinel-cli.sh 6           # 链接test6的Redis db=0"
    echo "    mjredis-sentinel-cli.sh 6 2         # 链接test6的Redis db=2"
    exit 0
fi
if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjredis-sentinel-cli.sh 6"
    exit 0
fi
if [[ ${dbNum} == "" ]]; then
  dbNum=0
fi

#redis-cli -h 192.168.1.50 -a Mj@tjsaowu@rDp -p 6979 -n ${dbNum} 2>/dev/null
#redis-cli -u "redis://Mj%40tjsaowu%40rDp@192.168.1.50:6979/${dbNum}" 2>/dev/null
redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} 2>/dev/null
