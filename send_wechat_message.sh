#!/bin/bash

# 帮助信息
show_help() {
  echo "使用方法: ./send_wechat_message.sh [联系人] [消息内容]"
  echo "例子:"
  echo "  ./send_wechat_message.sh                             # 使用默认联系人和消息"
  echo "  ./send_wechat_message.sh \"张三\"                      # 给张三发送默认消息"
  echo "  ./send_wechat_message.sh \"张三\" \"你好啊\"            # 给张三发送自定义消息"
  echo "  ./send_wechat_message.sh \"\" \"只想修改消息内容\"       # 使用默认联系人但自定义消息"
}

# 处理参数
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  show_help
  exit 0
fi

# 设置默认值
CONTACT="文件传输助手"
MESSAGE="123"

# 处理联系人参数
if [ -n "$1" ]; then
  CONTACT="$1"
fi

# 处理消息内容参数
if [ -n "$2" ]; then
  MESSAGE="$2"
elif [ -n "$1" ] && [ -z "$2" ]; then
  # 如果只提供了一个参数且第二个参数为空，检查是否有-c或--contact标志
  if [[ "$1" != "-c" && "$1" != "--contact" ]]; then
    # 如果不是联系人标志，默认为消息内容
    MESSAGE="$1"
    CONTACT="文件传输助手"
  fi
fi

echo "联系人: $CONTACT"
echo "消息内容: $MESSAGE"

# 运行Robot Framework脚本，并传递变量
python -m robot --variable CONTACT:"$CONTACT" --variable MESSAGE:"$MESSAGE" wechat_applescript_workflow.robot

echo "消息已发送完成!" 