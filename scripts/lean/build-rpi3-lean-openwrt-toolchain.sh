#!/bin/bash

# Export Env
export DEBIAN_FRONTEND=noninteractive

# Set config file
cd openwrt
rm -f .config .config.old
cp /home/admin/config/rpi3-lean-openwrt.config /home/admin/openwrt/.config

# Update & Install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Clone Community Packages
curl -fsSL https://raw.githubusercontent.com/SuLingGG/OpenWrt-Rpi/main/scripts/lean-openwrt.sh | bash

# Compile Tools
make defconfig
make tools/compile -j$(nproc) || make tools/compile -j1 V=s

# Compile Toolchain For Raspberry Pi 3
make toolchain/compile -j$(nproc) || make toolchain/compile -j1 V=s
make clean
rm -rf .config .config.old *.sh ../config ../scripts
