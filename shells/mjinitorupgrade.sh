#!/bin/sh

#workDir=$(cd $(dirname $0); pwd)
#cd ${workDir}

project=mj-sh
profile_sh_path=
hasProfile=0
targetPath=~/.${project}

check_bash_profile() {
    profileLine=$(grep "mj-sh" ~/.bash_profile)
    array=(${profileLine//:/ })
    profile_sh_path=${array[2]}
    echo "---- the path ----"
    echo ${profileLine}

    if [[ ${profile_sh_path} != "" ]]; then
        hasProfile=1
    else
        profile_sh_path=${targetPath}/shells
    fi
}

codePull() {
    cd ${profile_sh_path}/..
    echo "----start update code----"
    pwd

    if [[ ${hasProfile} == 0 ]]; then
        git clone http://192.168.1.75/devOps/mj-sh ${targetPath}
    else
        git pull
    fi
}

check_bash_profile
codePull

if [[ ${hasProfile} == 0 ]]; then
    echo "----add path----"
    echo "# 添加 mjxxx.sh 到环境变量" >> ~/.bash_profile
    echo "export PATH=\$PATH:${profile_sh_path}" >> ~/.bash_profile
fi

# 应用环境变量
source ~/.bash_profile

echo 当前可用脚本:
ls -F ./shells |grep "*"
