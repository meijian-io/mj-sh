#!/bin/sh
# 检测所有远程分支是否已合并master

showLog=$1  # -1、只打印master分支未合并的分支；1、只打印未合并master的分支；0、打印两者
source "$(dirname $0)/../resources/my.env.sh"

if [[ $1 == "showTips" ]]; then
    echo "tips---->> mjcode_master_haved.sh 1"
    echo "    -1、只打印master分支未合并的分支；1、只打印未合并master的分支；0、打印两者；没有则默认=1"
    exit 0
fi

if [[ -z ${showLog} ]]; then
  showLog=1
fi
checkLog() {
  git fetch
  remoteBranch=$(git branch -a | grep remotes | sed -e 's/.*origin\///g')
  for BRANCH in ${remoteBranch}; do
    git_dev_m=$(git log origin/${BRANCH} ^origin/master 2>/dev/null)
    if [[ -n "${git_dev_m}" ]]; then
      #master 不包含当前分支
      if [[ ${showLog} -le "0" ]]; then
        echo "[$(pwd)]项目 master 未合并 ${BRANCH}"
      fi
      git_m_d=$(git log origin/master ^origin/${BRANCH} 2>/dev/null)
      if [[ -n "${git_m_d}" && ${showLog} -ge "0" ]]; then
        #当前分支 不包含所有master内容
        echo "[$(pwd)]项目 ${BRANCH} 未合并 master"
      fi
    fi
  done
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        checkLog
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
