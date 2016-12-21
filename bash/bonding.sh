#!/bin/bash

#############################################################
# Usage:
#     bonding.sh -b bond0 -a IPADDRESS -m NETMASK -g GATEWAY -i INTERFACE1,INTERFACE2,...
BASE_MODPROB_DIR=/etc/modprobe.d/
BASE_NETWORK_DIR=/etc/sysconfig/network-scripts/

function usage {
	echo "  Usage:"
	echo "  bonding.sh -b bond0 -a IPADDRESS -m NETMASK -g GATEWAY -i INTERFACE1,INTERFACE2,..."
	echo "            Arguments -b -a -m -i must be included."
}


function die {
	>&2 echo "!!!!" $1
	usage
	exit 1
}

function bonding_mod_conf {
	echo "alias	$1	bonding" > $BASE_MODPROB_DIR/bonding.conf
	echo "options	bonding	mode=6 	miimon=100" >> $BASE_MODPROB_DIR/bonding.conf
	modprobe $1
	echo "Configured $1 in modprobe."
}

function bonding_intf_conf {
	echo "## Auto generated ....." > $BASE_NETWORK_DIR/ifcfg-$1
	echo "DEVICE=$1" >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "TYPE=Ethernet"  >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "ONBOOT=yes" >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "BOOTPROTO=static" >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "IPADDR=$2" >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "NETMASK=$3" >> $BASE_NETWORK_DIR/ifcfg-$1
	[ -z $4 ] || echo "GATEWAY=$4" >> $BASE_NETWORK_DIR/ifcfg-$1
	echo "USERCTL=no" >> $BASE_NETWORK_DIR/ifcfg-$1
}

function bonding_slave_conf {
	if [ -f $BASE_NETWORK_DIR/ifcfg-$1 ]; then 
		cat $BASE_NETWORK_DIR/ifcfg-$1 | \
			sed -e 's/ONBOOT.*/ONBOOT\=yes/g' | \
			sed -e 's/BOOTPROTO.*/BOOTPROTO\=none/g' | \
			sed -e 's/IPADDR.*//g' | \
			sed -e 's/NETMASK.*//g' | \
			sed -e 's/GATEWAY.*//g' | \
			sed -e "s/MASTER.*/MASTER\=$2/g" | \
			sed -e "s/SLAVE.*/SLAVE\=yes/g" | \
			sed -e 's/DNS.*//g' > ./tmp_slave_conf
		[ -z "$(grep "MASTER.*" $BASE_NETWORK_DIR/ifcfg-$1)" ] && echo "MASTER=$2" >> ./tmp_slave_conf
		[ -z "$(grep "SLAVE.*" $BASE_NETWORK_DIR/ifcfg-$1)" ] && echo "SLAVE=yes" >> ./tmp_slave_conf
		sed '/^$/d' ./tmp_slave_conf > $BASE_NETWORK_DIR/ifcfg-$1
		rm ./tmp_slave_conf
	else
		die "$BASE_NETWORK_DIR/ifcfg-$1 does not exist!"
	fi
}


while getopts ":b:a:m:g:i:" opt; do
  case $opt in
    b) bonding="$OPTARG"
    ;;
    a) ipaddr="$OPTARG"
    ;;
    m) netmask="$OPTARG"
    ;;
    g) gateway="$OPTARG"
    ;;
    i) interfaces="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

[ -z $bonding ] && die "Bonding name must be provided!"
[ -z $ipaddr ] && die "IP Address must be provided!"
[ -z $netmask ] && die "Netmask must be provided!"
[ -z $interfaces ] && die "Interfaces must be provided!"



printf "Binding: %s ...\n" "$bonding"
printf "IP Address: %s \n" "$ipaddr"
printf "Netmask: %s \n" "$netmask"
printf "Gateway: %s \n" "$gateway"
printf "Interfaces: %s \n" "$interfaces"



IFS=', ' read -a interfaces <<< "$interfaces"

bonding_mod_conf $bonding
bonding_intf_conf $bonding $ipaddr $netmask $gateway

for intf in "${interfaces[@]}"
do
	echo "configuring Interface: $intf"
	bonding_slave_conf $intf $bonding
done

echo "Configuration finished!. Try to restart networking..."
#service network restart
#echo "Networking restarted!"
