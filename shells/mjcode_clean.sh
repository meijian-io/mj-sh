#!/bin/sh

source "$(dirname $0)/../resources/my.env.sh"

loopProject() {
  #历遍ls命令显示目录
  for dir in $(ls); do
    if [ -d ${dir} ]; then
      cd $dir #进入某个目录
      if [ -f "pom.xml" ]; then
        echo "==>> mvn clean $(pwd)"
        mvn clean
      else
        echo "==error==>> 不是Maven项目，跳过：$(pwd)"
      fi
      echo ""
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
