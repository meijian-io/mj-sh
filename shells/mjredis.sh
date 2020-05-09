#!/bin/sh

# $1 = 环境，eg：1、2...
# $2 = 端口，默认：6379

if [[ $1 == "" ]]; then
    echo "input test env number[1/2/3...]:"
    exit 0
fi

port="6379"
if [[ $2 != "" ]]; then
    port=$2
fi
redis-cli -u "redis://liudatong@test$1:$port"
