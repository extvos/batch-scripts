#!/bin/bash

LOGS_PATH=/export/var/logs/nginx
_YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
YESTERDAY=${1:-$_YESTERDAY}
cat ${LOGS_PATH}/cal_result_${YESTERDAY}.txt
