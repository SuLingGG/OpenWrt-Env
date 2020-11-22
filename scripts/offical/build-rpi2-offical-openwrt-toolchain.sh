#!/bin/bash

# Export Env
export DEBIAN_FRONTEND=noninteractive

# Set config file
cd openwrt
rm -f .config .config.old
sed -i 's/luci.git/luci.git\;openwrt-19.07/g' feeds.conf.default
cp /home/admin/config/rpi2-offical-openwrt.config /home/admin/openwrt/.config

# Update & Install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Clone Community Packages
curl -fsSL https://raw.githubusercontent.com/SuLingGG/OpenWrt-Rpi/main/scripts/offical-openwrt.sh | bash

# Process Community Packages
./convert-translation.sh || true
./remove-upx.sh || true
./create-acl.sh -a || true

# Compile Tools
make defconfig
make tools/compile -j$(nproc) || make tools/compile -j1 V=s

# Compile Toolchain For Raspberry Pi 2
make toolchain/compile -j$(nproc) || make toolchain/compile -j1 V=s
make clean
rm -rf .config .config.old *.sh ../config ../scripts
