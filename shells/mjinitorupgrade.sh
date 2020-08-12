#!/bin/sh

project=mj-sh
hasProfile=0
targetPath=$(cd ~/.mj-sh; pwd)
profileFile=~/.bash_profile
echo "当前sh使用：$SHELL"
if [ $SHELL = "/bin/zsh" ]; then
  profileFile=~/.zshrc
fi

array=(${PATH//:/ })
for s in ${array[@]} ; do
  if [[ $s == *${project}* ]]; then
    echo "环境变量中脚本目录：$s"
    targetPath=$(cd $s/..; pwd)
  fi
done

if [[ -z ${MJ_SH_HOME} ]]; then
  MJ_SH_HOME=${targetPath}
  echo "添加 MJ_SH_HOME to ${profileFile}"
  echo "export MJ_SH_HOME=${MJ_SH_HOME}" >> ${profileFile}
fi
if [[ $PATH == *${project}* ]]; then
#  echo "当前环境变量中包含 .mj-sh"
  hasProfile=1
else
  echo "添加 mjxxx.sh to ${profileFile}"
  echo "# 添加 mjxxx.sh 到环境变量" >> ${profileFile}
  echo "export PATH=\$PATH:\$MJ_SH_HOME/shells" >> ${profileFile}
fi

codePull() {
    echo "start update code [${MJ_SH_HOME}]"
    if [[ ${hasProfile} == 0 ]]; then
        git clone http://192.168.1.75/devOps/mj-sh ${MJ_SH_HOME}
    fi
    cd ${MJ_SH_HOME}
    git pull --rebase
}
codePull

# 应用环境变量
source ${profileFile}

#echo 当前可用脚本:
#ls -F ${MJ_SH_HOME}/shells |grep "*"
