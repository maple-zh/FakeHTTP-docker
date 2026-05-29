FROM alpine:latest

# 安装运行时依赖
RUN apk add --no-cache \
    libnetfilter_queue \
    libnfnetlink \
    libmnl \
    iptables \
    ca-certificates \
    bash \
    wget  # 下载工具

# 复制下载脚本并执行
COPY download.sh /download.sh
RUN chmod +x /download.sh

# 在构建时根据 TARGETARCH 下载对应二进制文件
RUN /download.sh

# 复制入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
