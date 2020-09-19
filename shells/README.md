
## 脚本说明
- mjcheck-version.sh    检测当前目录下pom文件中的版本号。[示例详情](#mjcheck-version_case)
- mjcode_checkbranch.sh 所有项目，检测远程仓库中是否有该分支。[示例详情](#mjcode_checkbranch_case)
- mjcode_clean.sh       所有项目，clean
- mjcode_defbranch.sh   所有项目，比较分支是否包含分支。[示例详情](#mjcode_defbranch_case)
- mjcode_pull.sh        所有项目，更新 pull --rebase
- mjinitorupgrade.sh    脚本安装或更新
- mjk8sdebug.sh         debug测试环境服务 
- mjk8sdel.sh
- mjk8sexec.sh          进入测试容器内
- mjk8slog.sh           查询测试服务日志
- mjmavenDelSnapshot.sh 删除本地maven仓库快照包
- mjmongoconnect.sh     连接测试MongoDB数据库
- mjmysqlconnect.sh     连接测试MySQL数据库
- mjredis-sentinel-clear.sh 删除测试Redis数据
- mjredis-sentinel-cli.sh   连接测试Redis

### mjcheck-version_case

```
mjcheck-version.sh showTips   # 显示脚本可选参数提示
mjcheck-version.sh            # 检测当前目录下的所有 pom 文件中是否有快照包
mjcheck-version.sh snapshot   # 检测当前目录下的所有 pom 文件中是否有快照包
mjcheck-version.sh release    # 检测当前目录下的所有 pom 文件中的 meijian.RELEASE 包
mjcheck-version.sh all        # 检测当前目录下的所有 pom 文件中的所有 meijian 包
mjcheck-version.sh other      # 检测当前目录下的所有 pom 文件中的所有 非snapshot也非release
mjcheck-version.sh none       # 检测当前目录下的所有 pom 文件中的没有指定版本号的包
mjcheck-version.sh snapshot {realPath}
```

### mjcode_checkbranch_case

```
mjcode_checkbranch.sh publish     #检测远程origin仓库是否有 publish 分支，并打印有该分支的项目
mjcode_checkbranch.sh publish 1   #同上
mjcode_checkbranch.sh publish 0   #检测远程origin仓库是否有 publish 分支，并打印没有该分支的项目
```

### mjcode_defbranch_case

```
mjcode_defbranch.sh                 #比较当前分支是否已合并 origin/master
mjcode_defbranch.sh publish         #比较 publish 分支是否已合并 origin/master
mjcode_defbranch.sh publish master  #功能同上
mjcode_defbranch.sh master publish  #比较 master 是否已合并 publish
mjcode_defbranch.sh origin/publish  #比较 origin/publish 是否已合并 origin/master
mjcode_defbranch.sh origin/master origin/publish #比较 origin/master 是否已合并 origin/publish

mjcode_defbranch.sh publish master originName  #比较 originName/publish 分支是否已合并 originName/master
```