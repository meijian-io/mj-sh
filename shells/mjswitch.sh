#!/bin/sh

if [[ $1 == "" ]]; then
        echo "input test service name or 'all'"
        exit 0
fi

if [[ $2 == "" ]]; then
        echo "input test env number"
        exit 0
fi

switchEnv(){
    echo conf:$1
    pre_env=`cat $1 | grep "\"env\"" | grep -Eo '\d+'`
    if [[ $pre_env == "" ]]; then
            echo "parse pre env number faield"
            return
    fi
    echo switch form $pre_env to $2
    sed -i ""  "s/test$pre_env/test$2/g" $1
    cat $1
}


if [[ $1 == "all" ]]; then
    dir=`ls /conf`
    for file in $dir
    do
        switchEnv "/conf/$file" $2
    done
    exit 0
fi

if [[ -f "/conf/config-$1.conf" ]]; then
        file="/conf/config-$1.conf"
elif [[ -f "/conf/$1-config.conf" ]]; then
        file="/conf/$1-config.conf"
elif [[ -f "/conf/$1-config-center.conf" ]]; then
        file="/conf/$1-config-center.conf"
elif [[ -f "/conf/$1-config-app.conf" ]]; then
        file="/conf/$1-config-app.conf"
fi

cpConf(){
        if ssh root@test$2 "[ -f /conf/config-$1.conf ]"; then
                file="/conf/config-$1.conf"
        elif ssh root@test$2 "[ -f /conf/$1-config.conf ]"; then
                file="/conf/$1-config.conf"
        elif ssh root@test$2 "[ -f /conf/$1-config-center.conf ]"; then
                file="/conf/$1-config-center.conf"
        elif ssh root@test$2 "[ -f /conf/$1-config-app.conf ]"; then
                file="/conf/$1-config-app.conf"
        fi
        
        echo "copy $file from test$2"
        scp "root@test$2:/$file" /conf
}

if  [ ! -n "$file" ] ;then
        cpConf $1 $2
else
        switchEnv $file $2
fi

