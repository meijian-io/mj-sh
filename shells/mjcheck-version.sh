#!/usr/bin/env bash

shDir=$(cd $(dirname $0); pwd)
workDir=$(pwd)
userPath=$(cd ~; pwd)

# $1 = 检测什么，eg：all（所有非快照的meijian包） | snapshot（只检测快照包）
# $2 = 需要检测的项目路径，不传则取当前目录

doWhat=$1
projectPath=$2

if [[ ${workDir} == ${userPath} || $1 == "showTips" ]]; then
    echo "tips---->> cd到目标根目录，或 mjcheck-version.sh snapshot {realPath}"
    echo "tips---->> mjcheck-version.sh"
    echo "    snapshot（只检测快照包-默认）| release（所有meijian.RELEASE包）| all（所有meijian包）| other(非快照也非release) | none(没有指定版本)"
    exit 0
fi

if [[ ${projectPath} == "" ]]; then
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

checkOther() {
    python ${shDir}/py/checkVersionUpgrade.py other ${projectPath}
}
checkNone() {
    python ${shDir}/py/checkVersionUpgrade.py none ${projectPath}
}

case ${doWhat} in
all) checkAll ;;
release) checkRelease ;;
snapshot) checkSnapshot ;;
other) checkOther ;;
none) checkNone ;;
*) checkSnapshot ;;
esac