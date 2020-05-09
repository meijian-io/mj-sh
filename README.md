# 安装脚本

删除之前的配置
```bash
sed -i ".back" "/mj-sh-script/d" ~/.bash_profile
sed -i ".back" "/mjxxx.sh/d" ~/.bash_profile
```

安装或更新脚本使用：mjinitorupgrade.sh
```bash
git clone http://192.168.1.75/devOps/mj-sh ~/.mj-sh

~/.mj-sh/shells/mjinitorupgrade.sh
```
