#!/bin/sh
cd /tmp

rm -rf dscp
mkdir dscp
cd dscp

# get curl to support https
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/curl_7.17.1-1.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/libopenssl_0.9.8i-3.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/libcurl_7.17.1-1.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/zlib_1.2.3-5_mipsel.ipk

# install curl
tar xzf curl_7.17.1-1.2_mipsel.ipk ./data.tar.gz
tar xzf ./data.tar.gz
tar xzf libopenssl_0.9.8i-3.2_mipsel.ipk
tar xzf ./data.tar.gz
tar xzf libcurl_7.17.1-1.2_mipsel.ipk ./data.tar.gz
tar xzf ./data.tar.gz
tar xzf zlib_1.2.3-5_mipsel.ipk
tar xzf ./data.tar.gz

# get dscpmod from github
# http://github.com/pigworlds/dscpmod/raw/master/dscpmod.tar.bz
# https://raw.githubusercontent.com/pigworlds/dscpmod/master/dscpmod.tar.bz
LD_LIBRARY_PATH=usr/lib usr/bin/curl https://raw.githubusercontent.com/pigworlds/dscpmod/master/dscpmod.tar.bz --insecure >dscpmod.tar.bz

# extract
tar xjf dscpmod.tar.bz

# execute
chmod a+x iptables
insmod xt_DSCP.ko
./iptables -t mangle -A PREROUTING -i `nvram get wan_ifnames` -j DSCP --set-dscp 0

# dump iptables
./iptables -t mangle -L
