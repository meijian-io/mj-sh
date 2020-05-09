#!/bin/sh

if [[ $1 == "" ]]; then
        #statements
        echo "input log dir name"
        exit 0
fi

if [[ -d "/var/log/$1" ]]; then
        echo 文件夹已存在
        exit 0
fi

sudo mkdir /var/log/$1
sudo chmod -R 777 /var/log/$1
echo mkdir dir: /var/log/$1