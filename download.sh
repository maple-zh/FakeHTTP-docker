#!/bin/sh
set -e

# 默认版本号（可通过构建参数覆盖）
FAKEHTTP_VERSION="${FAKEHTTP_VERSION:-0.9.18}"
FAKESIP_VERSION="${FAKESIP_VERSION:-0.9.1}"

# 获取目标架构（由 Docker --build-arg TARGETARCH 传入）
ARCH="${TARGETARCH}"
if [ -z "$ARCH" ]; then
    echo "ERROR: TARGETARCH build argument is not set"
    exit 1
fi

# 映射 Docker 架构到官方 Release 文件名中的架构
case "$ARCH" in
    amd64) REAL_ARCH="x86_64" ;;
    arm64) REAL_ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# 下载并解压 FakeHTTP
echo "Downloading FakeHTTP ${FAKEHTTP_VERSION} for ${REAL_ARCH}..."
HTTP_URL="https://github.com/MikeWang000000/FakeHTTP/releases/download/${FAKEHTTP_VERSION}/FakeHTTP-linux-${REAL_ARCH}.tar.gz"
wget -q -O /tmp/fakehttp.tar.gz "$HTTP_URL"
tar -xzf /tmp/fakehttp.tar.gz -C /usr/local/bin/
rm /tmp/fakehttp.tar.gz

# 下载并解压 FakeSIP
echo "Downloading FakeSIP ${FAKESIP_VERSION} for ${REAL_ARCH}..."
SIP_URL="https://github.com/MikeWang000000/FakeSIP/releases/download/${FAKESIP_VERSION}/FakeSIP-linux-${REAL_ARCH}.tar.gz"
wget -q -O /tmp/fakesip.tar.gz "$SIP_URL"
tar -xzf /tmp/fakesip.tar.gz -C /usr/local/bin/
rm /tmp/fakesip.tar.gz

# 设置可执行权限
chmod +x /usr/local/bin/fakehttp /usr/local/bin/fakesip

echo "Download completed successfully."
