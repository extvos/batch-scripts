#!/bin/bash

function usage {
	echo 	"Usage: $0 -i CONFIGFILE [-d DATESTRING]"
}

function die {
	>&2 echo "!!!!" $1
	usage
	exit 1
}


while getopts ":i:d:" opt; do
  case $opt in
    i) cfgfile="$OPTARG"
    ;;
    d) lastdate="$OPTARG"
    ;;
    \?) echo "Usage: $0 -i CONFIGFILE [-d DATESTRING]" >&2 && exit 1
    ;;
  esac
done

_LASTDATE=$(date -d "a week ago" +%Y/%m/%d)
LASTDATE=${lastdate:-$_LASTDATE}
INIFILE=${cfgfile:-cdi-luzhi.ini}

[ -f $INIFILE ]  || die "Can not find file $INIFILE !!!"

for x in `grep ^directory ${INIFILE} | awk -F '=' '{ print $2 }'`
do
    echo "Cleaning ${x}/${LASTDATE} ..."
    rm -rf ${x}/${LASTDATE}
done
