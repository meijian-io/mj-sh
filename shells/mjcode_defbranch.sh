#!/bin/sh
# 检测分支2-${branchDev}是否已包含分支1-${branchMaster}

branchDev=$1    # 检测目标分支，比如开发分支
branchMaster=$2 # 检测被包含分支，比如：master
originName=$3   #远程仓库名称，为空检测本地分支
source "$(dirname $0)/../resources/my.env.sh"

if [[ -z ${branchDev} ]]; then
  branchDev=header
fi
if [[ -z ${branchMaster} ]]; then
  branchMaster=master
fi

defM=${branchMaster}
defD=${branchDev}
if [[ -n ${originName} ]]; then
  defM=${originName}/${branchMaster}
  defD=${originName}/${branchDev}
else
  if [[ ${branchMaster} == "master" ]]; then
    branchMaster=origin/master
  fi
fi

checkLog() {
  git fetch
  git_m_d=$(git log ${defM} ^${defD} 2>/dev/null)
  if [[ -n "${git_m_d}" ]]; then
    echo "[$(pwd)]项目分支 ${branchDev} 未合并 ${branchMaster}"
  fi
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
