#!/bin/sh

del_package=$1

get_local_setEnv() {
    mvnRepo=$(mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]')
    sleep 3s
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
