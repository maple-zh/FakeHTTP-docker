#!/bin/sh
set -e

FAKEHTTP_VERSION="${FAKEHTTP_VERSION:-0.9.18}"
FAKESIP_VERSION="${FAKESIP_VERSION:-0.9.1}"
ARCH="${TARGETARCH}"

if [ -z "$ARCH" ]; then
    echo "ERROR: TARGETARCH build argument is not set"
    exit 1
fi

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
mkdir -p /tmp/fakehttp_extract
tar -xzf /tmp/fakehttp.tar.gz -C /tmp/fakehttp_extract
# 查找解压出来的二进制文件（可能名为 fakehttp 或 FakeHTTP）
FAKEHTTP_BIN=$(find /tmp/fakehttp_extract -type f -executable -name 'fakehttp' -o -name 'FakeHTTP' | head -n1)
if [ -z "$FAKEHTTP_BIN" ]; then
    echo "ERROR: Could not find fakehttp binary in extracted files"
    ls -la /tmp/fakehttp_extract
    exit 1
fi
cp "$FAKEHTTP_BIN" /usr/local/bin/fakehttp
rm -rf /tmp/fakehttp.tar.gz /tmp/fakehttp_extract

# 下载并解压 FakeSIP
echo "Downloading FakeSIP ${FAKESIP_VERSION} for ${REAL_ARCH}..."
SIP_URL="https://github.com/MikeWang000000/FakeSIP/releases/download/${FAKESIP_VERSION}/FakeSIP-linux-${REAL_ARCH}.tar.gz"
wget -q -O /tmp/fakesip.tar.gz "$SIP_URL"
mkdir -p /tmp/fakesip_extract
tar -xzf /tmp/fakesip.tar.gz -C /tmp/fakesip_extract
FAKESIP_BIN=$(find /tmp/fakesip_extract -type f -executable -name 'fakesip' -o -name 'FakeSIP' | head -n1)
if [ -z "$FAKESIP_BIN" ]; then
    echo "ERROR: Could not find fakesip binary in extracted files"
    ls -la /tmp/fakesip_extract
    exit 1
fi
cp "$FAKESIP_BIN" /usr/local/bin/fakesip
rm -rf /tmp/fakesip.tar.gz /tmp/fakesip_extract

chmod +x /usr/local/bin/fakehttp /usr/local/bin/fakesip
echo "Download completed successfully."
