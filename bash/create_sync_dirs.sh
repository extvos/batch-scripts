#!/bin/bash
inifile=${1:-cdi-luzhi.ini}
grep -Eo '/dev/shm/[a-z0-9/]+' ${inifile} | xargs -n 1 mkdir -p