#!/usr/bin/env bash

shDir=$(cd $(dirname $0); pwd)
workDir=$(pwd)
userPath=$(cd ~; pwd)

# $1 = 检测什么，eg：all（所有非快照的meijian包） | snapshot（只检测快照包）
# $2 = 需要检测的项目路径，不传则取当前目录

doWhat=$1
projectPath=$2

if [[ ${workDir} == ${userPath} ]]; then
    echo "tips---->> cd到目标根目录，或 mjcheck-version.sh snapshot {realPath}"
    echo "tips---->> mjcheck-version.sh snapshot（只检测快照包-默认）| release（所有meijian.RELEASE包）| all（所有meijian包）"
    exit 0
fi

if [[ ${projectPath} == "" ]]; then
    echo "tips---->> cd到目标根目录，或 mjcheck-version.sh snapshot {realPath}"
    echo "tips---->> mjcheck-version.sh snapshot（只检测快照包-默认）| release（所有meijian.RELEASE包）| all（所有meijian包）"
    projectPath=${workDir}
fi

checkAll() {
    python ${shDir}/py/checkVersionUpgrade.py all ${projectPath}
}

checkRelease() {
    python ${shDir}/py/checkVersionUpgrade.py release ${projectPath}
}

checkSnapshot() {
    python ${shDir}/py/checkVersionUpgrade.py snapshot ${projectPath}
}

case ${doWhat} in
all) checkAll ;;
release) checkRelease ;;
snapshot) checkSnapshot ;;
*) checkSnapshot ;;
esac