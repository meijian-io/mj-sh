#!/bin/sh

branchName=$1 # 空=当前分支，不为空则checkout
source "$(dirname $0)/../resources/my.env.sh"

codePull() {
  gitUrl=$(git remote get-url origin)
  echo ${gitUrl}
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        codePull
#      else
#        echo "==error==>> 不是Git仓库，跳过：$(pwd)"
      fi
      cd ../
    fi
  done
}

for projectG in ${mj_projectsGroup[@]}; do
  if [ -d ${projectG} ]; then
    echo ">>>>[projectGroup pull start]====== ${projectG}"
    cd ${projectG}
    loopProject
    echo ">>>>[projectGroup pull end]====== ${projectG}"
#  else
#    echo "==error==>> 不是个文件夹，跳过：${projectG}"
  fi
done
