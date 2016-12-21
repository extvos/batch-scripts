#!/bin/bash
LOGS_PATH=/export/var/logs/nginx
_YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
YESTERDAY=${1:-$_YESTERDAY}
cd /tmp
tar zxf ${LOGS_PATH}/access_${YESTERDAY}.tar.gz
TOTAL_REQUEST=`cat /tmp/${LOGS_PATH}/access_${YESTERDAY}.log|wc -l`
HIT=`grep HIT /tmp/${LOGS_PATH}/access_${YESTERDAY}.log|wc -l`
EXPIRED=`grep EXPIRED /tmp/${LOGS_PATH}/access_${YESTERDAY}.log|wc -l`
MISS=`grep MISS /tmp/${LOGS_PATH}/access_${YESTERDAY}.log|wc -l`
LUZHI=`grep /luzhi /tmp/${LOGS_PATH}/access_${YESTERDAY}.log|wc -l`

echo "${TOTAL_REQUEST}" > ${LOGS_PATH}/cal_result_${YESTERDAY}.txt
echo "${HIT}" >> ${LOGS_PATH}/cal_result_${YESTERDAY}.txt
echo "${EXPIRED}" >> ${LOGS_PATH}/cal_result_${YESTERDAY}.txt
echo "${MISS}" >> ${LOGS_PATH}/cal_result_${YESTERDAY}.txt
echo "${LUZHI}" >> ${LOGS_PATH}/cal_result_${YESTERDAY}.txt

rm -f /tmp/${LOGS_PATH}/access_${YESTERDAY}.log