#!/usr/bin/env bash

newBr=feature/monitor
checkToBr=$1

gitCheckout() {

    if [[ ${checkToBr} != "" ]]; then
        git checkout ${checkToBr}
    fi

    br=`git branch | grep "*"`
    echo "${br/* /}     $(pwd)"
}

gitPull() {

    git pull
}

gitCreateBr() {

    if [[ ${newBr} != "" ]]; then
        git branch ${newBr}
        git push origin ${newBr}:${newBr}
    fi
}

dir=`ls ~/work/serverProjects/`
for projectDir in ${dir} ; do
    if [[ ${projectDir} =~ "seazen" || ${projectDir} =~ "sass" ]]; then
        echo "跳过 ${projectDir} 包含字符串seazen"
        continue
    fi
    cd ~/work/serverProjects/${projectDir}

    gitCheckout
    gitPull
    gitCreateBr
done

#cd ~/work/serverProjects/meijian-channel/
#gitCheckout
#gitPull