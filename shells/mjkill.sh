#!/bin/sh
# 杀死进程, 移除端口占用

if [ -n "`echo $1|sed s/[0-9]//g`" ]
then 
    # name, 用grep找
    # 过滤进程列表，不显示grep&mjkill对应的进程，awk从第二列获取进程ID
    ID=`ps -ef | grep "$1" | grep -v "grep"| grep -v "mjkill" | awk '{print $2}'`
    if [ "$ID" =  "" ]
    then
        echo "No process be found to killed!"
        exit 0
    else
        echo 'found ID list:' $ID
        for pid in $ID
            do
            echo "kill $pid"
            kill -9 $pid
            done
        exit 0
    fi
else
    # port, 直接用lsof
    name=$(lsof -i:$1|tail -1|awk '"$1"!=""{print $2}')
    if [ -z $name ]
    then
        echo "No process be found to killed!"
        exit 0
    fi
    id=$(lsof -i:$1|tail -1|awk '"$1"!=""{print $2}')
    kill -9 $id
    echo "kill $name($id)"
    exit 0
fi
