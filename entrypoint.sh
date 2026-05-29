#!/bin/bash
set -e

# 从环境变量读取参数，如果没有设置则使用空字符串
FAKEHTTP_ARGS="${FAKEHTTP_ARGS:-}"
FAKESIP_ARGS="${FAKESIP_ARGS:-}"

# 通过环境变量分别传递参数，启动两个进程
fakehttp $FAKEHTTP_ARGS "$@" &
fakesip $FAKESIP_ARGS "$@" &

# 等待任意一个子进程退出
wait -n

# 退出时，终止所有后台任务
kill $(jobs -p) 2>/dev/null
exit 1
