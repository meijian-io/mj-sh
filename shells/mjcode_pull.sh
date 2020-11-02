#!/bin/sh

branchName=$1 # 空=当前分支，不为空则checkout
source "$(dirname $0)/../resources/my.env.sh"

if [[ $1 == "showTips" ]]; then
    echo "tips---->> mjcode_pull.sh"
    echo "    mjcode_pull.sh        #拉取当前分支最新代码"
    echo "    mjcode_pull.sh dev    #切换分支到 dev，并拉取最新代码"
    echo "    mjcode_pull.sh all    #master 未合并的所有分支，创建分支并拉取最新代码"
    exit 0
fi

pulAllBranch() {
  remoteBranch=$(git branch -a | grep remotes | sed -e 's/.*origin\///g')
  for BRANCH in ${remoteBranch}; do
    git_dev_m=$(git log origin/${BRANCH} ^origin/master 2>/dev/null)
    if [[ -n "${git_dev_m}" ]]; then
      #master 不包含当前分支
      git checkout -B ${BRANCH} origin/${BRANCH}
      git pull --rebase
    fi
  done
  git checkout master
}

codePull() {
  echo "==>> git pull [$(pwd)]"
  git fetch
  if [[ ${branchName} == "all" ]]; then
    pulAllBranch
  else
    if [[ ${branchName} != "" ]]; then
      git checkout -B ${branchName} origin/${branchName}
    fi
    git pull --rebase
  fi
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        codePull
      else
        echo "==error==>> 不是Git仓库，跳过：$(pwd)"
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
  else
    echo "==error==>> 不是个文件夹，跳过：${projectG}"
  fi
done
