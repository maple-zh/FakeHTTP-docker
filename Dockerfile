FROM alpine:latest

# 安装运行时依赖和工具
RUN apk add --no-cache \
    libnetfilter_queue \
    libnfnetlink \
    libmnl \
    iptables \
    ca-certificates \
    bash \
    wget

# 复制下载脚本并执行
COPY download.sh /download.sh
RUN chmod +x /download.sh

# 下载二进制文件（构建参数 TARGETARCH 由 docker build --build-arg 传入）
ARG TARGETARCH
RUN /download.sh

# 复制入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
