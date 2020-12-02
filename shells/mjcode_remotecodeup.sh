#!/bin/sh

source "$(dirname $0)/../resources/my.env.sh"
delUpdate=$1

if [[ $1 == "showTips" ]]; then
    echo "tips---->>"
    echo "  mjcode_remotecodeup.sh       # 替换远程仓库地址为云效代码库（删除替换）"
    echo "  mjcode_remotecodeup.sh this  # 只替换当前仓库远程地址为云效"
    exit 0
fi

reset() {
  remotes=$(git remote)
  if [[ ${remotes} =~ "mj_gitlab_backup" ]]; then
    echo "-->reset remote to mj_gitlab_backup"
    git remote remove origin
    git remote rename mj_gitlab_backup origin
  fi
  git remote -v
}

codePull() {
  echo ""
  echo "==>> git remote update [$(pwd)]"
  reset
  oldUrl=$(git remote get-url origin)
  newUrl=""
  if [[ -n $(echo ${oldUrl} | grep "http") ]]; then
    newUrl=$(echo ${oldUrl} | sed 's/http:\/\/192.168.1.75/git@codeup.aliyun.com:meijian/g')
  else
    newUrl=$(echo ${oldUrl} | sed 's/git@192.168.1.75:/git@codeup.aliyun.com:meijian\//g')
  fi
  if [[ ${oldUrl} == ${newUrl} ]]; then
    echo "==error update URL==>>${oldUrl}"
  else
    echo "-->remote update [${oldUrl}] to [${newUrl}]"
    git remote set-url origin ${newUrl}
    git config remote.origin.pushurl ${newUrl}
    git remote -v
  fi
}

if [[ $1 == "this" ]]; then
  codePull
else
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
fi
