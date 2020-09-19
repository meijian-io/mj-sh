#!/bin/sh

branchName=$1 # 空=当前分支，不为空则checkout
source "$(dirname $0)/../resources/my.env.sh"

codePull() {
  echo "==>> git pull $(pwd)"
  if [[ ${branchName} != "" ]]; then
    git checkout ${branchName}
  fi
  git pull --rebase
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    cd $dir #进入某个目录
    codePull
    cd ../
  done
}

for projectG in ${mj_projectsGroup[@]}; do
  echo ">>>>[projectGroup pull start]====== ${projectG}"
  cd ${projectG}
  loopProject
  echo ">>>>[projectGroup pull end]====== ${projectG}"
done
