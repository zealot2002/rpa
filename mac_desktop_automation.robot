*** Settings ***
Documentation     macOS桌面自动化示例
Library           Process
Library           OperatingSystem
Library           Collections

*** Tasks ***
使用AppleScript操作macOS应用
    # 打开文本编辑器(TextEdit)
    ${result}=    Run Process    osascript    -e    tell application "TextEdit" to activate
    Log    ${result.stdout}
    
    # 等待应用打开
    Sleep    1s
    
    # 输入文字
    ${result}=    Run Process    osascript    -e    tell application "System Events" to keystroke "你好，Robot Framework!"
    Log    ${result.stdout}
    
    # 保存文件 (Cmd+S)
    ${result}=    Run Process    osascript    -e    tell application "System Events" to keystroke "s" using command down
    Log    ${result.stdout}
    
    # 关闭应用
    ${result}=    Run Process    osascript    -e    tell application "TextEdit" to quit
    Log    ${result.stdout} 