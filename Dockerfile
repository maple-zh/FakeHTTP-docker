# 阶段一：构建阶段
FROM alpine:latest AS builder

# 安装编译依赖
RUN apk add --no-cache \
    build-base \
    gcc \
    make \
    musl-dev \
    libnetfilter_queue-dev \
    libnfnetlink-dev \
    libmnl-dev \
    linux-headers \
    git

# 1. 编译 FakeHTTP
WORKDIR /tmp/FakeHTTP
RUN git clone https://github.com/MikeWang000000/FakeHTTP.git . && \
    make && \
    make install

# 2. 编译 FakeSIP
WORKDIR /tmp/FakeSIP
RUN git clone https://github.com/MikeWang000000/FakeSIP.git . && \
    make && \
    make install

# 阶段二：运行阶段
FROM alpine:latest

# 安装运行时依赖
RUN apk add --no-cache \
    libnetfilter_queue \
    libnfnetlink \
    libmnl \
    iptables \
    ca-certificates \
    bash

# 从构建阶段复制二进制文件
COPY --from=builder /usr/local/bin/fakehttp /usr/local/bin/fakehttp
COPY --from=builder /usr/local/bin/fakesip /usr/local/bin/fakesip

# 复制并设置入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
