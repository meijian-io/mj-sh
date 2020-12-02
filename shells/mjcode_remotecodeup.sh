#!/bin/sh

source "$(dirname $0)/../resources/my.env.sh"
delUpdate=$1

if [[ $1 == "showTips" ]]; then
    echo "tips---->>"
    echo "  mjcode_remotecodeup.sh      # 替换远程仓库地址为云效代码库（并备份）"
    echo "  mjcode_remotecodeup.sh del  # 替换远程仓库地址为云效代码库（删除替换）"
    echo "  mjcode_remotecodeup.sh reset  # 替换远程仓库地址为云效代码库（删除替换）"
    exit 0
fi

reset() {
  if [[ ${delUpdate} == "reset" ]]; then
    oldUrl=$(git remote get-url origin)
    newUrl=$(echo ${oldUrl} | sed 's/git@codeup.aliyun.com:meijian\//git@192.168.1.75:/g')
    echo "-->reset remote url ${oldUrl} to ${newUrl}"
    git remote remove origin
    git remote remove mj_gitlab_backup
    git remote add origin ${newUrl}
    git remote -v
  fi
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
  if [[ -n ${newUrl} ]]; then
    echo "-->remote update [${oldUrl}] to [${newUrl}]"
    if [[ ${delUpdate} == "del" || ${delUpdate} == "reset" ]]; then
      git remote remove origin
    else
      git remote rename origin mj_gitlab_backup
    fi
    git remote add origin ${newUrl}
    git remote -v
  else
    echo "==error==远程仓库地址替换失败==>>${oldUrl}"
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
