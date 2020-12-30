#!/bin/sh

del_package=$1
source "$(dirname $0)/../resources/my.env.sh"

if [[ ${mj_m2_local_repository} == "" ]]; then
#    get_local_setEnv
    echo ".mj-sh/resources/my.env.sh中增加本地Maven仓库配置，eg：mj_m2_local_repository=xxx"
    echo "可通过下面的命令得到本地仓库地址"
    echo "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'"
    exit 0
fi
cd ${mj_m2_local_repository}
pwd
if [[ ! -n "$del_package" ]]; then
  echo "没有入参------删除所有快照包"

  find . -name "*-SNAPSHOT"
  find . -name "*-SNAPSHOT" | xargs rm -rf {} \;
  find . -name "*.SNAPSHOT"
  find . -name "*.SNAPSHOT" | xargs rm -rf {} \;
else
  echo "有入参------删除 ./com/meijian/${del_package} 快照包"

  find ./com/meijian/${del_package} -name "*-SNAPSHOT"
  find ./com/meijian/${del_package} -name "*-SNAPSHOT" | xargs rm -rf {} \;
  find ./com/meijian/${del_package} -name "*.SNAPSHOT"
  find ./com/meijian/${del_package} -name "*.SNAPSHOT" | xargs rm -rf {} \;
fi
