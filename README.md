# [OpenWrt-Env](https://github.com/SuLingGG/OpenWrt-Env)

[![GitHub Stars](https://img.shields.io/github/stars/SuLingGG/OpenWrt-Env.svg?style=flat-square&label=Stars&logo=github)](https://github.com/SuLingGG/OpenWrt-Env/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/SuLingGG/OpenWrt-Env.svg?style=flat-square&label=Forks&logo=github)](https://github.com/SuLingGG/OpenWrt-Env/fork)
[![Docker Stars](https://img.shields.io/docker/stars/sulinggg/openwrtenv.svg?style=flat-square&label=Docker%20Stars&logo=docker)](https://hub.docker.com/r/sulinggg/openwrtenv)
[![Docker Pulls](https://img.shields.io/docker/pulls/sulinggg/openwrtenv.svg?style=flat-square&label=Docker%20Pulls&logo=docker&color=orange)](https://hub.docker.com/r/sulinggg/openwrtenv)

本项目基于 P3TERX 大佬的 [openwrt-build-env](https://github.com/P3TERX/openwrt-build-env) 项目，在镜像构建过程中，使用了 Project-OpenWrt [build-scripts](https://github.com/project-openwrt/build-scripts) 项目中的 [init_build_environment.sh](https://github.com/project-openwrt/build-scripts/blob/master/init_build_environment.sh) 脚本来安装编译 OpenWrt 所需的依赖。

Github: <https://github.com/SuLingGG/OpenWrt-Env>

DockerHub: <https://hub.docker.com/r/sulinggg/openwrtenv>

此镜像包含以下特性:

1. 已预置完善的 OpenWrt 依赖，无需手动安装；
2. 预置了配置好的 zsh，方便终端操作；
3. 预置一些实用的小工具和配置，例如 bashtop，gotop，tmate，oh-my-zsh，oh-my-tmux 等；
4. 预先配置好了 SSH，方便进行远程连接 (详情请前往 P3TERX 大佬项目的 [README.md](https://github.com/P3TERX/openwrt-build-env#ssh-security-settings) 查看)
5. 提供包含 Lean / Project / 和官方 OpenWrt 源码并且预编译树莓派 1~4 工具链的镜像，减少工具链编译时间。

以下内容转自 P3TERX 大佬的 openwrt-build-env 项目，并根据本项目实际情况进行了些许修改 (比如用户名等):

## 镜像介绍

### 基础镜像

基础镜像包含了构建 OpenWrt 的依赖与一些小工具，未预置 OpenWrt 源码与工具链，适合构建任意设备的 OpenWrt。

基础镜像的拉取方式为 (DockerHub)：

```
docker pull sulinggg/openwrtenv
```

或 (阿里云香港 Docker 镜像仓库) ：

```
docker pull registry.cn-hongkong.aliyuncs.com/suling/openwrtenv
```

### 工具链镜像

工具链镜像在基础镜像上集成了 OpenWrt 源码，并且预编译了树莓派 1~4 四个设备的工具链，适合编译适用于树莓派的 OpenW让他，可以减少 20~60 分钟的编译时间。

以下为工具链镜像的标签名称列表：

|   树莓派版本    |   Lean    |   Offical    |   Project    |
| :-------------: | :-------: | :----------: | :----------: |
|    树莓派 1B    | lean-rpi1 | offical-rpi1 | project-rpi1 |
|    树莓派 2B    | lean-rpi2 | offical-rpi2 | project-rpi2 |
| 树莓派 3B / 3B+ | lean-rpi3 | offical-rpi3 | project-rpi3 |
|    树莓派 4B    | lean-rpi4 | offical-rpi4 | project-rpi4 |

工具链镜像的拉取方式为 (DockerHub)：

```
docker pull sulinggg/openwrtenv:标签名称
```

或 (阿里云香港 Docker 镜像仓库) ：

```
docker pull registry.cn-hongkong.aliyuncs.com/suling/openwrtenv:标签名称
```

比如，从 DockerHub 拉取 Lean 版 OpenWrt 源码且适用于树莓派 3B/3B+ 的工具链镜像，则：

```
docker pull sulinggg/openwrtenv:lean-rpi3
```

其中，

Lean 版源码基于 [coolsnowwolf/lede:master](https://github.com/coolsnowwolf/lede/tree/master);

Offical 版源码基于 [openwer/openwrt:master](https://github.com/openwrt/openwrt/tree/master)；

Project 版源码基于 [project-openwrt/openwrt:18.06-kernel5.4](https://github.com/project-openwrt/openwrt/tree/18.06-kernel5.4)。

OpenWrt 源码所在路径为 `/home/admin/openwrt`。

## 使用镜像 (以基础镜像为例)

### 拉取镜像

从 DockerHub 拉取镜像:

```
docker pull sulinggg/openwrtenv
```

如果你在国内，可以考虑从阿里云 Docker 镜像仓库 (香港) 拉取镜像:

```
docker pull registry.cn-hongkong.aliyuncs.com/suling/openwrtenv
```

构建镜像:

```
docker build -t sulinggg/openwrtenv github.com/SuLingGG/OpenWrt-Env
```

### 启动容器

```
docker run \
    -itd \
    --name openwrtenv \
    -p 10022:22 \
    -v ~/workspace:/home/admin/workspace \
    sulinggg/openwrtenv
```

### 容器权限设置

在宿主机内使用 `id` 命令来查看当前用户的 uid 与 gid:

```
$ id
uid=1001(p3terx) gid=1002(p3terx)
```

使用 `docker exec` 命令来设定 admin 用户的 uid 和 gid:

```
docker exec openwrtenv sudo usermod -u 1001 admin
docker exec openwrtenv sudo groupmod -g 1002 admin
```

设定目录容器内工作目录 (/home/admin) 的所有权:

```
docker exec openwrtenv sudo chown -hR admin:admin .
```

重启容器:

```
docker restart openwrtenv
```

### 进入容器

在宿主机终端中使用 `docker exec` 命令进入容器:

```
docker exec -it openwrtenv zsh
```
