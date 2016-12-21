#!/bin/bash
inifile=${1:-cdi-luzhi.ini}
for x in `grep ^directory ${inifile} | awk -F '=' '{ print $2 }'`
do
    echo ">>>> ${x} <<<<"
    grep "New segment" ${x}/hls-sync.log | tail -n 1
    echo ""
done
