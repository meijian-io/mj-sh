#!/usr/bin/env bash

#workDir=$(cd $(dirname $0); pwd)
#cd ${workDir}/..

envNum=$1

if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjmysqlconnect.sh 1"
    exit 0
fi

echo "-------- start connect test${envNum} MySQL -------- "

#MYSQL=`which mysql`
##$MYSQL test -u root << EOF
#echo ${MYSQL}

echo "mysql -htest${envNum} -uroot -P3306 -p"
mysql -htest${envNum} -uroot -P3306 -p

# mysql  -h  主机名(ip)  -u  用户名 -P 端口 -p
