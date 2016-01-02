#!/bin/sh
cd /tmp

#rm -rf dscp
mkdir dscp
cd dscp

# get curl to support https
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/curl_7.17.1-1.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/libopenssl_0.9.8i-3.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/libcurl_7.17.1-1.2_mipsel.ipk
wget http://downloads.openwrt.org/kamikaze/8.09.2/ar7/packages/zlib_1.2.3-5_mipsel.ipk

# install curl
tar -xzO -f curl_7.17.1-1.2_mipsel.ipk ./data.tar.gz | tar xvz
tar -xzO -f libopenssl_0.9.8i-3.2_mipsel.ipk ./data.tar.gz | tar xvz
tar -xzO -f libcurl_7.17.1-1.2_mipsel.ipk ./data.tar.gz | tar xvz
tar -xzO -f zlib_1.2.3-5_mipsel.ipk ./data.tar.gz | tar xvz

# get dscpmod from github and decompress
# https://github.com/pigworlds/dscpmod/raw/master/dscpmod.tar.bz
# https://raw.githubusercontent.com/pigworlds/dscpmod/master/dscpmod.tar.bz
LD_LIBRARY_PATH=usr/lib usr/bin/curl https://raw.githubusercontent.com/pigworlds/dscpmod/master/dscpmod.tar.bz --insecure | tar xvj

# execute
chmod a+x iptables
insmod xt_DSCP.ko
./iptables -t mangle -A PREROUTING -i `nvram get wan_ifnames` -j DSCP --set-dscp 0
./iptables -t mangle -A POSTROUTING -o `nvram get wan_ifnames` -j DSCP --set-dscp-class EF

# dump iptables
./iptables -t mangle -L
