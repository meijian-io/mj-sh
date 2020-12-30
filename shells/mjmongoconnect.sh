#!/usr/bin/env bash

envNum=$1
port=27017

if [[ ${envNum} == "" ]]; then
    echo "[error] input test env number，eg： mjmongoconnect.sh 1"
    exit 0
fi

echo "-------- start connect test${envNum} MongoDB -------- "

mongo --host mongodb.meijian-test${envNum}.svc.cluster.local --port ${port}

# mongo --host host --port port --authenticationDatabase database -u user -p password
