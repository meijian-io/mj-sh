#!/usr/bin/env bash
sh_path=`dirname $0`
workDir=$(pwd)

projectPath=$1 # 不传默认为（~/work/serverProjects）、传（this）表示只更新当前目录、传决定路径表示-更新当前目录下的所有子目录
branchName=$2  # 空=当前分支，不为空则checkout
isThis=

git_pull() {
    if [[ ${branchName} != "" ]]; then
        git checkout ${branchName}
    fi
    git pull --rebase
}

if [[ ${projectPath} == "" ]]; then
    projectPath=~/work/serverProjects
elif [[ ${projectPath} == "this" ]]; then
    projectPath=${workDir}
    isThis=1
fi

cd ${projectPath}
if [[ ${isThis} ]]; then
    echo "==>>"
    echo "${projectPath}"
    git_pull
else
    for project in `ls` ; do
        cd ${projectPath}/${project}
        echo "==>>"
        pwd
        git_pull
    done
fi
