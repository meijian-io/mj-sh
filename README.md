# 安装脚本

删除之前的配置
```bash
sed -i ".back" "/mjxxx.sh/d" ~/.bash_profile
sed -i ".back" "/mj-sh-script/d" ~/.bash_profile
```

安装或更新脚本使用：mjinitorupgrade.sh
```bash
git clone http://192.168.1.75/devOps/mj-sh ~/.mj-sh

~/.mj-sh/shells/mjinitorupgrade.sh
```

## mjk8s**.sh 使用

使用前提：
### 1. 拷贝配置文件：~/.kube/config
> mkdir ~/.kube ; cp ~/.mj-sh/resources/devuser.kubeconfig ~/.kube/config

### 2. 安装命令：kubectl
在 macOS 上用 Homebrew 安装 kubectl (**推荐**)
> brew install kubernetes-cli

[安装kubectl-官网](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl/#%E5%AE%89%E8%A3%85-kubectl)

查看版本
> kubectl version

## mjredis-**.sh 使用

使用前提：
1. 命令：redis-cli

在 macOS 上用 Homebrew 安装 redis (**推荐**)
> brew install redis

[Redis下载安装-官网](https://redis.io/download)
```bash
wget http://download.redis.io/releases/redis-6.0.3.tar.gz
tar xzf redis-6.0.3.tar.gz
cd redis-6.0.3
make
```

查看版本
> redis-cli --version
