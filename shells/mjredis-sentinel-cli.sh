#!/bin/bash

envNum=$1
dbNum=0
host=192.168.1.50
port=6979
pwd=Mj@tjsaowu@rDp

if [[ ${envNum} == "" ]]; then
  echo "eg1：mjredis-sentinel-cli.sh t1（t1环境，db=10...）"
  echo "eg2：mjredis-sentinel-cli.sh 8（db=8）"
  dbNum=0
elif [[ ${envNum} == "t1" ]]; then
  dbNum=10
elif [[ ${envNum} == "t2" ]]; then
  dbNum=20
elif [[ ${envNum} == "t3" ]]; then
  dbNum=30
elif [[ ${envNum} == "t4" ]]; then
  dbNum=40
elif [[ ${envNum} == "t5" ]]; then
  dbNum=50
elif [[ ${envNum} == "t6" ]]; then
  dbNum=60
elif [[ ${envNum} == "t7" ]]; then
  dbNum=70
elif [[ ${envNum} == "t8" ]]; then
  dbNum=80
elif [[ ${envNum} == "t9" ]]; then
  dbNum=90
else
  echo "eg1：mjredis-sentinel-cli.sh t1（t1环境，db=10...）"
  echo "eg2：mjredis-sentinel-cli.sh 8（db=8）"
  dbNum=$1
fi

#redis-cli -h 192.168.1.50 -a Mj@tjsaowu@rDp -p 6979 -n ${dbNum} 2>/dev/null
#redis-cli -u "redis://Mj%40tjsaowu%40rDp@192.168.1.50:6979/${dbNum}" 2>/dev/null
redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} 2>/dev/null
