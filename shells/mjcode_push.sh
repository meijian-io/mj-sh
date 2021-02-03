#!/bin/sh

param=$1
targetGit=$2
source "$(dirname $0)/../resources/my.env.sh"
logPath=$(dirname $0)/../logs.codePush.log

if [[ $1 == "showTips" ]]; then
  echo "tips---->> $0"
  echo "  $0          # 只打印URL，不做任何处理"
  echo "  $0 first    # 首次推送master，并自动创建远程仓库"
  echo "  $0 repo     # 更换remote为群核地址"
  echo "  $0 all      # push所有分支"
  echo "  $0 repo ali # 更换remote为阿里云codeup地址"
  exit 0
fi

replaceUrl() {
  oldUrl=$(git remote get-url origin)
  if [[ ${oldUrl} =~ "songluGroup/" || ${oldUrl} =~ "material/" || ${oldUrl} =~ "board/" || ${oldUrl} =~ "itemShape/" || ${oldUrl} =~ "utils_py3/" || ${oldUrl} =~ "train/" ]]; then
    # 算法组所有仓库地址增加一层目录
    if [ ! ${targetGit} ]; then
      newUrl=$(echo ${oldUrl} | sed 's/git@codeup.aliyun.com:meijian\//git@gitlab.qunhequnhe.com:meijianGroups\/imageAlgo\//g')
    elif [ ${targetGit} == "ali" ]; then
      newUrl=$(echo ${oldUrl} | sed 's/git@gitlab.qunhequnhe.com:meijianGroups\/imageAlgo\//git@codeup.aliyun.com:meijian\//g')
    fi
  else
    if [ ! ${targetGit} ]; then
      newUrl=$(echo ${oldUrl} | sed 's/git@codeup.aliyun.com:meijian\//git@gitlab.qunhequnhe.com:meijianGroups\//g')
    elif [ ${targetGit} == "ali" ]; then
      newUrl=$(echo ${oldUrl} | sed 's/git@gitlab.qunhequnhe.com:meijianGroups\//git@codeup.aliyun.com:meijian\//g')
    fi
  fi
}
firstPush() {
  echo "push $(pwd) to ${newUrl}"
  echo "push $(pwd) to ${newUrl}" >>${logPath} &
  git push --set-upstream ${newUrl} master
  #  if [ $? -eq 0 ]; then
  #    echo "push succeed，then change remote"
  #  else
  #    echo "push failed"
  #  fi
  git config branch.master.remote origin
}
changeRepo() {
  if [[ ${oldUrl} != "${newUrl}" ]]; then
    git remote set-url origin ${newUrl}
    git config remote.origin.pushurl ${newUrl}
    git remote -v
    echo "change remote from [${oldUrl}] to [${newUrl}]" >>${logPath} &
  fi
}
pushAllBranch() {
  allBranch=$(git branch -a | grep remotes | sed -e 's/.*origin\///g')
  for BRANCH in ${allBranch}; do
    echo ${BRANCH}
    git_dev_m=$(git log ${BRANCH} ^master 2>/dev/null)
    if [[ -n "${git_dev_m}" || ${BRANCH} == "master" || ${BRANCH} == "publish" ]]; then
      #master 不包含当前分支
      git push origin ${BRANCH}:${BRANCH}
    else
      echo "master分支已包含[${BRANCH}]内容，不用再push了"
    fi
  done
  git checkout master
}

codePush() {
  #  echo "==>> git push [$(pwd)]"
  oldUrl=""
  newUrl=""
  replaceUrl
  if [ ! ${param} ]; then
    echo "--> remote oldUrl  [${oldUrl}]"
    echo "--> newUrl [${newUrl}]"
  elif [ "first" == ${param} ]; then
    firstPush
  elif [ "repo" == ${param} ]; then
    changeRepo
  elif [ "all" == ${param} ]; then
    pushAllBranch
  fi
}

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -d "./.git" ]; then
        codePush
        #      else
        #        echo "==error==>> 不是Git仓库，跳过：$(pwd)"
      fi
      cd ../
    fi
  done
}

#codePush
for projectG in ${mj_projectsGroup[@]}; do
  if [ -d ${projectG} ]; then
    echo ">>>>[projectGroup  start]====== ${projectG}"
    cd ${projectG}
    loopProject
    echo ">>>>[projectGroup  end]====== ${projectG}"
  else
    echo "==error==>> 不是个文件夹，跳过：${projectG}"
  fi
done
