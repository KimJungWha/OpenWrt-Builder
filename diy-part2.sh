#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
pwd 
rm -rf $(find $PWD -name "*luci-theme-argon*")
git clone https://github.com/jerrykuku/luci-theme-argon package/

sed -i '/exit/d' package/default-settings/files/zzz-default-settings
cat >> package/default-settings/files/zzz-default-settings <<-'EOF'
echo "#30 4 * * * sleep 70 && touch /etc/banner && reboot" >> /etc/crontabs/root

uci set luci.main.mediaurlbase=/luci-static/argon
uci commit luci

sed -i '/lienol/d' /etc/opkg/distfeeds.conf
sed -i '/other/d' /etc/opkg/distfeeds.conf
sed -i '/kenzo/d' /etc/opkg/distfeeds.conf
sed -i '/small/d' /etc/opkg/distfeeds.conf

sed -i 's/downloads.openwrt.org/openwrt.proxy.ustclug.org/g' /etc/opkg/distfeeds.conf

uci set network.lan.ipaddr='192.168.1.254'
uci set network.lan.netmask='255.255.255.0'
uci commit network

sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g    ' /etc/shadow

exit 0
EOF
