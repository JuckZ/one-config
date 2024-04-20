#!/bin/zsh

# 设置 zsh 的 echo 行为以支持 -e
setopt BSD_ECHO

# 日志级别
typeset -A log_levels
log_levels=(
    [DEBUG]=0
    [INFO]=1
    [WARNING]=2
    [ERROR]=3
    [CRITICAL]=4
)

typeset -A log_colors
log_colors=(
  # 蓝色
  [DEBUG]=$'\e[1;34m'
  # 绿色
  [INFO]=$'\e[1;32m'
  # 黄色
  [WARNING]=$'\e[1;33m'
  # 红色
  [ERROR]=$'\e[1;31m'
  # 紫红色
  [CRITICAL]=$'\e[1;35m'
)
reset_color=$'\e[0m'

# 默认日志级别
LOG_LEVEL="DEBUG"

temp_dir=${TMPDIR:-/tmp}
formatted_date=$(date "+%Y-%m-%d")
# 构建最终的日志文件路径
LOG_FILE="${temp_dir}one-config_${formatted_date}.log"

# 打印和保存日志的函数
function log_message() {
    local level=$1
    local message=$2
    local color=${log_colors[$1]}
    local level_num=${log_levels[$LOG_LEVEL]}
    local msg_level_num=${log_levels[$level]}
    if (( msg_level_num >= level_num )); then
        echo "${color}${level}: ${message}${reset_color}"
        echo "${level}: ${message}" >> $LOG_FILE
    fi
}
