#!/usr/bin/env bash

projectPath=~/work/serverProjects
projectName=meijian-config
tattletalePath=~/work/tools/tattletale-1.1.2.Final

if [[ $1 != "" ]]; then
    projectName=$1
fi

mvn_package() {
    cd ${projectPath}/${projectName}
    echo "------ 当前项目 ------"
    pwd
    mvn clean package -Dmaven.test.skip=true
}

run_tattletale() {
    cd ${tattletalePath}
    echo "开始分析------${projectName}"
    java -Xmx512m -jar tattletale.jar ${projectPath}/${projectName} output/${projectName}
}

if [[ ! -d "${projectPath}/${projectName}" ]]; then
  echo "文件夹不存在====>>${projectPath}/${projectName}"
  exit 1
fi

mvn_package
run_tattletale
