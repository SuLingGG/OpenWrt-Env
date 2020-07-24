#!/bin/bash

# Export Env
export DEBIAN_FRONTEND=noninteractive

# Set config file
cd openwrt
rm -f .config .config.old
sed -i 's/luci.git/luci.git\;openwrt-19.07/g' feeds.conf.default
cp /home/admin/config/rpi3-offical-openwrt.config /home/admin/openwrt/.config

# Update & Install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Clone Community Packages
./clone-community-packages.sh

# Process Community Packages
./convert-translation.sh || true
./remove-upx.sh || true

# Compile Tools
make defconfig
make tools/compile -j$(nproc) || make tools/compile -j1 V=s

# Compile Toolchain For Raspberry Pi 3
make toolchain/compile -j$(nproc) || make toolchain/compile -j1 V=s
make clean
rm -rf .config .config.old *.sh ../config ../scripts
