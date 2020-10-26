#!/bin/sh
# 检测远程仓库，是否有该分支

branchName=$1 # 要检测的分支名称
showHave=$2   # 默认=1；0、打印不包含分支的项目，1、打印包含该分支的项目
source "$(dirname $0)/../resources/my.env.sh"

if [[ $1 == "showTips" ]]; then
    echo "tips---->> mjcode_checkbranch.sh publish"
    echo "  mjcode_checkbranch.sh publish     #检测远程origin仓库是否有 publish 分支，并打印有该分支的项目"
    echo "  mjcode_checkbranch.sh publish 1   #同上"
    echo "  mjcode_checkbranch.sh publish 0   #检测远程origin仓库是否有 publish 分支，并打印没有该分支的项目"
    exit 0
fi

if [[ ${branchName} == "" ]]; then
  read -p "[error] 请输入你要检测的分支名称：" branchName
  if [[ ${branchName} == "" ]]; then
    echo "[error] 必须有需要检测的分支名"
    exit 0
  fi
fi
if [[ ${showHave} == "" ]]; then
  showHave=1
fi

codeCheck() {
  #  echo "==>> git check $(pwd)"
  git fetch
  git_commit_id=$(git rev-parse --verify "origin/${branchName}" 2>/dev/null)
  if [[ -n "${git_commit_id}" && ${showHave} == 1 ]]; then
    echo "[$(pwd)]项目远程仓库有[${branchName}]分支"
  fi
  if [[ -z "${git_commit_id}" && ${showHave} == 0  ]]; then
    echo "[$(pwd)]项目远程仓库没有[${branchName}]分支"
  fi
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        codeCheck
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
