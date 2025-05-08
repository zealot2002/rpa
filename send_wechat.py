#!/usr/bin/env python3
"""
微信自动发送消息工具

使用方法:
python send_wechat.py [联系人] [消息内容]

例子:
python send_wechat.py                       # 使用默认联系人和消息
python send_wechat.py "张三"                 # 给张三发送默认消息
python send_wechat.py "张三" "你好啊"        # 给张三发送自定义消息
python send_wechat.py "" "只想修改消息内容"  # 使用默认联系人但自定义消息

若不提供参数，默认发送给"文件传输助手"，消息内容为"123"
"""

import sys
import subprocess
import os
import argparse

def send_wechat_message(contact="文件传输助手", message="123"):
    """发送微信消息的函数
    
    参数:
        contact (str): 联系人名称
        message (str): 要发送的消息内容
    
    返回:
        bool: 是否发送成功
    """
    print(f"准备发送微信消息:")
    print(f"联系人: \"{contact}\"")
    print(f"消息内容: \"{message}\"")
    
    # 构建Robot Framework命令
    cmd = [
        "python", "-m", "robot",
        "--variable", f"CONTACT:{contact}",
        "--variable", f"MESSAGE:{message}",
        "wechat_applescript_workflow.robot"
    ]
    
    # 运行命令
    try:
        result = subprocess.run(cmd, check=True, text=True, capture_output=True)
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"错误: 发送消息失败 - {e}")
        print(e.stdout)
        print(e.stderr)
        return False

def main():
    # 创建命令行参数解析器
    parser = argparse.ArgumentParser(description='微信自动发送消息工具')
    parser.add_argument('contact', nargs='?', default='文件传输助手', 
                        help='联系人名称 (默认: 文件传输助手)')
    parser.add_argument('message', nargs='?', default='123', 
                        help='要发送的消息内容 (默认: 123)')
    parser.add_argument('-c', '--contact', dest='contact_flag', 
                        help='使用标志形式指定联系人')
    parser.add_argument('-m', '--message', dest='message_flag', 
                        help='使用标志形式指定消息内容')
    
    args = parser.parse_args()
    
    # 确定实际使用的联系人和消息
    contact = args.contact_flag if args.contact_flag else args.contact
    message = args.message_flag if args.message_flag else args.message
    
    # 特殊情况：只提供了一个位置参数，没有指定是什么
    if len(sys.argv) == 2 and not (args.contact_flag or args.message_flag):
        # 默认视为消息内容
        message = sys.argv[1]
        contact = "文件传输助手"
    
    # 发送消息
    success = send_wechat_message(contact, message)
    
    if success:
        print("消息发送成功！")
    else:
        print("消息发送失败，请检查日志。")
        
    print(f"日志文件位置: {os.path.abspath('wechat_applescript_log.txt')}")

if __name__ == "__main__":
    main() 