#!/bin/sh

mvnRepo=$(mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]')
del_package=$1

cd ${mvnRepo}
pwd

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
