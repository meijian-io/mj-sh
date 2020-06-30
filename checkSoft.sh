#!/usr/bin/env bash

read -p "请输入你要检测的软件，并回车继续：" softName

softPath=$(which ${softName})

if [[ ${softPath} == "" ]]; then
    echo "没有安装软件：${softName}"
else
    echo "安装了软件：${softPath}"
fi