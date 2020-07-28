#!/bin/sh

del_package=$1

get_local_setEnv() {
    mvnRepo=$(mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]')
    sleep 3s
    echo "M2_LOCAL_REPOSITORY=${mvnRepo}"
    read -p "确定要添加上面的环境变量吗？y/n。" envAdd
    if [ ${envAdd} != "y" ]; then
        exit 0
    fi
    echo "export M2_LOCAL_REPOSITORY=${mvnRepo}" >> ~/.bash_profile
    source ~/.bash_profile
    if [[ -f "$HOME/.zshrc" ]]; then
        echo "存在zshrc ➜  ~ source ~/.zshrc"
        source ~/.zshrc
    fi
}

mvnRepo=${M2_LOCAL_REPOSITORY}
if [[ ${mvnRepo} == "" ]]; then
    get_local_setEnv
fi
cd ${mvnRepo}

read -p "确定要删除 [${mvnRepo}] 目录下的 \"*-SNAPSHOT\" 包吗？y/n。" delSanpshot
if [ ${delSanpshot} != "y" ]; then
    exit 0
fi

if [[ ! -n "$del_package" ]]; then
  echo "没有入参------删除所有快照包"

  find . -name "*-SNAPSHOT"
  find . -name "*-SNAPSHOT" | xargs rm -rf {} \;
else
  echo "有入参------删除 ./com/meijian/${del_package} 快照包"

  find ./com/meijian/${del_package} -name "*-SNAPSHOT"
  find ./com/meijian/${del_package} -name "*-SNAPSHOT" | xargs rm -rf {} \;
#   | xargs rm -rf {} \;
#   -exec rm -rf {} \;
fi
