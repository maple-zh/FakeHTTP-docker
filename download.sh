#!/bin/sh
set -e

# 定义下载函数
download_binary() {
    local name=$1
    local version=$2
    local arch=$3
    # 注意: 由于官方二进制包命名中没有 x86_64，需要做一次映射
    case "$arch" in
        amd64) real_arch="x86_64" ;;
        arm64) real_arch="arm64" ;;
        *) echo "Unsupported architecture: $arch"; exit 1 ;;
    esac
    url="https://github.com/MikeWang000000/${name}/releases/download/${version}/${name}-linux-${real_arch}.tar.gz"
    echo "Downloading ${url}"
    wget -q -O "/tmp/${name}.tar.gz" "$url"
    tar -xzf "/tmp/${name}.tar.gz" -C /usr/local/bin/
    rm -f "/tmp/${name}.tar.gz"
}

# 从环境变量获取版本号，若无则使用最新稳定版
FAKEHTTP_VERSION="${FAKEHTTP_VERSION:-0.9.18}"
FAKESIP_VERSION="${FAKESIP_VERSION:-0.9.1}"
TARGETARCH="${TARGETARCH}"

echo "Building for architecture: $TARGETARCH"
download_binary "FakeHTTP" "$FAKEHTTP_VERSION" "$TARGETARCH"
download_binary "FakeSIP" "$FAKESIP_VERSION" "$TARGETARCH"
