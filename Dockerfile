#=================================================
# https://github.com/P3TERX/openwrt-build-env
# Description: OpenWrt build environment in docker
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# Mod: SuLingGG
# Blog: https://mlapp.cn
#=================================================

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get upgrade -qqy && \
    apt-get install -qqy git sudo wget curl zsh vim nano tmux tree htop screen gnupg ca-certificates uuid-runtime tzdata openssh-server lrzsz xz-utils && \
    wget -q https://build-scripts.project-openwrt.eu.org/init_build_environment.sh && \
    sed -i 's/apt install/apt-get install/g' init_build_environment.sh && \
    sed -i 's/apt clean/apt-get clean/g' init_build_environment.sh && \
    sed -i 's/apt full-upgrade/apt-get full-upgrade/g' init_build_environment.sh && \
    sed -i '/Chinese/d' init_build_environment.sh && \
    chmod +x init_build_environment.sh && \
    ./init_build_environment.sh > /dev/null 2>&1 && \
    rm init_build_environment.sh && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /var/run/sshd && \
    useradd -m -G sudo -s /usr/bin/zsh admin && \
    echo 'admin:admin' | chpasswd && \
    echo 'admin ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/admin && \
    chmod 440 /etc/sudoers.d/admin && \
    curl -fsSL git.io/tmate.sh | bash && \
    curl -fsSL git.io/gotop.sh | bash -s install && \
    curl -fsSL git.io/bashtop.sh | bash -s install && \
    mkdir -p /home/admin && \
    cd /home/admin && \
    mkdir -p /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    HOME="/home/admin" && \
    curl -fsSL git.io/oh-my-zsh.sh | bash && \
    curl -fsSL git.io/oh-my-tmux.sh | bash && \
    chown -R admin:admin /home/admin

USER admin
WORKDIR /home/admin

ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8

EXPOSE 22

CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
