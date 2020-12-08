#!/bin/sh

# 代码所在的上级文件夹，支持多个文件夹中间空格：("dir1" "dir2" "dir3")
mj_projectsGroup=("${HOME}/work/MeiJian/serverProject")

# Maven本地仓库地址
mj_m2_local_repository=${HOME}/tools/apache-maven-3.3.3/repository

mj_package_username="云效制品库用户名，同maven的settings.xml"
mj_package_password="云效制品库密码，同maven的settings.xml"
