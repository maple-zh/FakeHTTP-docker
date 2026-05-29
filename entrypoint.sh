#!/bin/bash
set -e

# 从环境变量读取专属参数
FAKEHTTP_ARGS="${FAKEHTTP_ARGS:-}"
FAKESIP_ARGS="${FAKESIP_ARGS:-}"

# 启动两个进程（公共参数通过 "$@" 传递）
fakehttp $FAKEHTTP_ARGS "$@" &
fakesip $FAKESIP_ARGS "$@" &

# 等待任意子进程退出
wait -n

# 终止所有后台任务
kill $(jobs -p) 2>/dev/null
exit 1
