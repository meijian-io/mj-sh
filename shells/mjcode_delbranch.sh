#!/bin/sh

branchName=$1 # 空=当前分支，不为空则checkout
source "$(dirname $0)/../resources/my.env.sh"

if [[ $1 == "showTips" ]]; then
  echo "tips---->> mjcode_delbranch.sh"
  echo "    mjcode_delbranch.sh dev    #删除分支 dev"
  echo "    mjcode_delbranch.sh all    #删除 master 已合并的分支"
  exit 0
fi

if [[ -z ${branchName} || ${branchName} == "master" ]]; then
  echo "请输入要删除的分支名，另 master 不可删除; mjcode_delbranch.sh dev"
  exit 0
fi

delAllBranch() {
  remoteBranch=$(git branch -a | grep remotes | sed -e 's/.*origin\///g')
  for BRANCH in ${remoteBranch}; do
    if [[ ${BRANCH} == "master" || ${BRANCH} == "publish" ]]; then
        continue
    fi
    git_dev_m=$(git log origin/${BRANCH} ^origin/master 2>/dev/null)
    if [[ -z "${git_dev_m}" ]]; then
      echo "--> master已包含当前分支[${BRANCH}]所有内容"
      git branch -d ${BRANCH}
      git push origin --delete ${BRANCH}
    fi
  done
}

delBranch() {
  echo "==>> git delBranch [$(pwd)]"
  git fetch
  git remote prune origin
  if [[ ${branchName} == "all" ]]; then
    delAllBranch
  else
    git_dev_m=$(git log origin/${branchName} ^origin/master 2>/dev/null)
    if [[ -n "${git_dev_m}" ]]; then
      echo "分支[${branchName}]比较master有新增内容"
    fi
    read -p "确定要删除本地与远程分支[${branchName}]吗？1=all，2=only local：" choose
    case ${choose} in
    1)
      git branch -d ${branchName}
      git push origin --delete ${branchName}
      ;;
    2)
      git branch -d ${branchName}
      ;;
    *)
      echo "skip"
      ;;
    esac
  fi
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        delBranch
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
