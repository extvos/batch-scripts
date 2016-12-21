#!/bin/bash
inifile=${1:-cdi-luzhi.ini}
grep ^directory ${inifile} | awk -F '=' '{ print $2 }' | xargs -n 1 mkdir -p