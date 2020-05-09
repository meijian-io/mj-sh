#!/bin/sh

if [[ $1 == "" ]]; then
    #statements
    echo "input test env number"
    exit 0
fi
if [ $1 == "75" ]; then
    ssh root@192.168.1.75
elif [ $1 == "jmp" ]; then
    ssh root@mj.jump
elif [ $1 == "79" ]; then
    ssh root@192.168.1.79
elif [ $1 == "48" ]; then
    ssh root@192.168.1.48
else
  ssh root@test$1
fi
