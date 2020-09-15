#!/bin/sh

source "$(cd $(dirname $0); pwd)/../resources/my.env.sh"

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    cd $dir #进入某个目录
    echo "==>> mvn clean $(pwd)"
    mvn clean
    echo ""
    cd ../
  done
}

for projectG in ${mj_projectsGroup[@]}; do
  echo ">>>>[projectGroup start clean]====== ${projectG}"
  cd ${projectG}
  loopProject
  echo ">>>>[projectGroup clean end]====== ${projectG}"
done
