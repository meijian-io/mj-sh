#!/bin/sh

#workDir=$(cd $(dirname $0); pwd)
tattletalePath=~/work/tools/tattletale-1.1.2.Final

cd ${tattletalePath}/output
pwd

nohup python -m SimpleHTTPServer 8000 >>/opt/tattletalelog/output.log &