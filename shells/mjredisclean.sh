#!/bin/sh

redisKeyPattern=$1  #要删除的key正则
redisHost=$2        #环境，eg：test1 | 127.0.0.1 | ...
redisDb=$3          #db，默认：0
redisPort=$4        #端口，默认：6379

if [[ ${redisKeyPattern} == "" ]]; then
  echo "请输入需要删除的key正则，eg: mjredisclean.sh "test*" 127.0.0.1 0 6379"
  exit 0
fi
if [[ ${redisHost} == "" ]]; then
    echo "input the host，eg: mjredisclean.sh "test*" 127.0.0.1 0 6379"
    exit 0
fi
if [[ ${redisPort} == "" ]]; then
    redisPort="6379"
fi
if [[ ${redisDb} == "" ]]; then
    redisDb=0
fi

echo "===="
echo "redis-cli -u \"redis://liudatong@${redisHost}:${redisPort}/${redisDb}\" keys \"${redisKeyPattern}\""

redis-cli -u "redis://liudatong@${redisHost}:${redisPort}/${redisDb}" keys "${redisKeyPattern}" | xargs --no-run-if-empty redis-cli -u "redis://liudatong@${redisHost}:${redisPort}/${redisDb}" del

#|awk "NR>1"
