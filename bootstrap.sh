#!/bin/sh
cd /tmp

rm -rf dscp
mkdir dscp
cd dscp

# get dscpmod from azure and decompress
wget http://dscpmodasus.azurewebsites.net/dscpmod.tar.bz -O dscpmod.tar.bz
tar xvjf dscpmod.tar.bz

# execute
chmod a+x iptables
insmod xt_DSCP.ko
./iptables -t mangle -A PREROUTING -i `nvram get wan_ifnames` -j DSCP --set-dscp 0

# dump iptables
./iptables -t mangle -L
