*** Settings ***
Documentation     微信自动化任务示例
Library           Process
Library           OperatingSystem
Library           Collections

*** Tasks ***
微信发送消息自动化
    # 激活微信窗口
    ${result}=    Run Process    osascript    -e    tell application "WeChat" to activate
    Log    ${result.stdout}
    
    # 等待应用窗口完全激活
    Sleep    1s
    
    # 确保焦点在输入框（点击输入区域）
    # 这个命令假设微信窗口已经打开并且当前聊天窗口是您想要发送消息的窗口
    ${result}=    Run Process    osascript    -e    tell application "System Events" to keystroke tab
    Log    ${result.stdout}
    
    # 输入文本 "123"
    ${result}=    Run Process    osascript    -e    tell application "System Events" to keystroke "123"
    Log    ${result.stdout}
    
    # 按回车键发送消息
    ${result}=    Run Process    osascript    -e    tell application "System Events" to key code 36
    Log    ${result.stdout} 