#!/bin/bash

# $1 要删除的key 正则
# $2 哪个db，默认db=0

pattern=$1
dbNum=$2
host=192.168.1.50
port=6979
pwd=Mj@tjsaowu@rDp

if [[ ${pattern} == "" ]]; then
  echo "请输入需要删除的key正则，eg：mjredis-sentinel-clear.sh \"*userId*\" 10"
  exit 0
fi
if [[ ${dbNum} == "" ]]; then
  dbNum=0
fi

redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} keys "${pattern}" 2>/dev/null | xargs redis-cli -h ${host} -p ${port} -a ${pwd} -n ${dbNum} del 2>/dev/null
