*** Settings ***
Documentation     微信完整自动化流程 (AppleScript版本)
...               自动搜索联系人并发送消息
Library           Process
Library           OperatingSystem
Library           Collections
Library           DateTime

*** Variables ***
${LOG_FILE}       ${CURDIR}/wechat_applescript_log.txt
${MESSAGE}        123    # 默认消息内容
${CONTACT}        文件传输助手    # 默认联系人

*** Tasks ***
完整微信AppleScript自动化工作流
    创建日志文件
    执行基于AppleScript的微信自动化    ${CONTACT}    ${MESSAGE}
    记录完成信息

*** Keywords ***
创建日志文件
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Create File    ${LOG_FILE}    # 微信自动化工作流日志 (AppleScript版本)\n# 开始时间: ${timestamp}\n\n

记录日志
    [Arguments]    ${message}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${log_entry}=    Catenate    SEPARATOR=\n    [${timestamp}] ${message}
    Append To File    ${LOG_FILE}    ${log_entry}\n
    Log To Console    ${log_entry}

执行基于AppleScript的微信自动化
    [Arguments]    ${target_contact}=文件传输助手    ${custom_message}=123
    记录日志    步骤1: 使用AppleScript激活微信窗口
    记录日志    联系人: "${target_contact}"
    记录日志    将发送的消息内容: "${custom_message}"
    
    # 激活微信窗口
    ${result1}=    Run Process    osascript    -e    tell application "WeChat" to activate
    记录日志    AppleScript激活微信窗口结果: ${result1.stdout}
    
    # 等待窗口激活
    Sleep    1s
    记录日志    步骤2: 等待窗口激活完成
    
    # 获取当前聊天联系人 - 使用AppleScript更准确地检测
    ${get_current_contact_script}=    Catenate    SEPARATOR=\n
    ...    tell application "System Events"
    ...        tell process "WeChat"
    ...            set windowTitle to name of front window
    ...            log "当前窗口标题: " & windowTitle
    ...            
    ...            # 尝试检查当前聊天窗口的各种UI元素
    ...            # 首先检查标题
    ...            set foundContact to windowTitle contains "${target_contact}"
    ...            
    ...            # 尝试查找聊天窗口顶部的联系人名称文本
    ...            if not foundContact then
    ...                try
    ...                    # 尝试获取聊天窗口中的联系人名称
    ...                    set topUIElements to UI elements of front window
    ...                    repeat with elem in topUIElements
    ...                        try
    ...                            set elemName to name of elem
    ...                            log "检查UI元素: " & elemName
    ...                            if elemName contains "${target_contact}" then
    ...                                set foundContact to true
    ...                                exit repeat
    ...                            end if
    ...                        on error
    ...                            log "无法获取UI元素名称"
    ...                        end try
    ...                    end repeat
    ...                on error
    ...                    log "无法获取顶部UI元素"
    ...                end try
    ...            end if
    ...            
    ...            return "窗口标题: " & windowTitle & ", 是否找到联系人: " & foundContact
    ...        end tell
    ...    end tell
    
    ${result_contact}=    Run Process    osascript    -e    ${get_current_contact_script}    stderr=STDOUT
    记录日志    当前聊天窗口检查: ${result_contact.stdout}
    
    # 检查是否已经在正确的聊天窗口
    ${is_correct_window}=    Set Variable    ${FALSE}
    记录日志    初始化窗口检查状态: is_correct_window = ${is_correct_window}
    
    # 检查结果中是否包含"是否找到联系人: true"
    ${status}=    Run Keyword And Return Status    Should Contain    ${result_contact.stdout}    是否找到联系人: true
    记录日志    窗口联系人检查结果: status = ${status}, 寻找的联系人: "${target_contact}"
    
    # 基于检查结果设置窗口状态
    ${is_correct_window}=    Set Variable    ${status}
    记录日志    最终窗口检查状态: is_correct_window = ${is_correct_window}
    
    # 如果不在正确的聊天窗口，则搜索联系人
    Run Keyword If    not ${is_correct_window}    记录日志    需要搜索联系人: 当前窗口不是目标联系人窗口
    Run Keyword If    ${is_correct_window}    记录日志    无需搜索联系人: 当前已经在目标联系人窗口
    
    Run Keyword If    not ${is_correct_window}    搜索并选择联系人    ${target_contact}
    
    # 等待聊天窗口加载完成
    Sleep    1s
    记录日志    步骤3: 聊天窗口已准备就绪
    
    # 现在输入框应该有焦点，之前的联系人搜索可能导致窗口状态不稳定，点击输入区域确保焦点
    ${focus_input_script}=    Catenate    SEPARATOR=\n
    ...    tell application "System Events"
    ...        tell process "WeChat"
    ...            # 找到消息输入区域并点击
    ...            # 微信的输入区域通常是底部的文本区域
    ...            # 这里尝试点击窗口底部区域，应该会点击到输入框
    ...            set inputPosition to position of front window
    ...            set inputSize to size of front window
    ...            set clickX to inputPosition's item 1 + (inputSize's item 1 div 2)
    ...            set clickY to inputPosition's item 2 + inputSize's item 2 - 100
    ...            click at {clickX, clickY}
    ...        end tell
    ...    end tell
    
    ${result_focus}=    Run Process    osascript    -e    ${focus_input_script}
    记录日志    确保输入框获得焦点: ${result_focus.stdout}
    Sleep    0.5s
    
    # 使用剪贴板方法输入消息文本
    记录日志    步骤4: 准备输入消息文本
    
    # 使用AppleScript将消息文本复制到剪贴板
    ${clipboard_script}=    Catenate    SEPARATOR=\n
    ...    set the clipboard to "${custom_message}"
    
    ${result2}=    Run Process    osascript    -e    ${clipboard_script}
    记录日志    将消息复制到剪贴板: ${result2.stdout}
    
    # 粘贴文本 (使用Command+V)
    ${result3}=    Run Process    osascript    -e    tell application "System Events" to keystroke "v" using command down
    记录日志    粘贴消息文本结果: ${result3.stdout}
    
    # 按回车发送消息
    记录日志    步骤5: 按回车键发送消息
    ${result4}=    Run Process    osascript    -e    tell application "System Events" to key code 36
    记录日志    发送消息结果: ${result4.stdout}
    
    # 综合自动化脚本
    记录日志    步骤6: 执行备用综合自动化脚本
    ${applescript}=    Catenate    SEPARATOR=\n
    ...    tell application "WeChat" to activate
    ...    delay 1
    ...    -- 检查当前是否已在目标联系人的窗口
    ...    set isTargetWindow to false
    ...    tell application "System Events"
    ...        tell process "WeChat"
    ...            set windowTitle to name of front window
    ...            log "DEBUG: 当前窗口标题: " & windowTitle
    ...            log "DEBUG: 目标联系人: ${target_contact}"
    ...            
    ...            -- 首先检查窗口标题
    ...            if windowTitle contains "${target_contact}" then
    ...                set isTargetWindow to true
    ...            end if
    ...            
    ...            -- 如果窗口标题未找到，尝试检查其他UI元素
    ...            if not isTargetWindow then
    ...                try
    ...                    set topElements to UI elements of front window
    ...                    repeat with elem in topElements
    ...                        try
    ...                            set elemName to name of elem
    ...                            log "DEBUG: 检查UI元素: " & elemName
    ...                            if elemName contains "${target_contact}" then
    ...                                set isTargetWindow to true
    ...                                exit repeat
    ...                            end if
    ...                        on error
    ...                            log "DEBUG: 无法检查UI元素"
    ...                        end try
    ...                    end repeat
    ...                on error
    ...                    log "DEBUG: 无法获取UI元素"
    ...                end try
    ...            end if
    ...            
    ...            log "DEBUG: 是否在目标窗口: " & isTargetWindow
    ...        end tell
    ...    end tell
    ...    
    ...    -- 如果不在目标窗口，则搜索联系人
    ...    if not isTargetWindow then
    ...        log "DEBUG: 需要搜索联系人"
    ...        tell application "System Events"
    ...            keystroke "f" using command down
    ...            delay 0.5
    ...        end tell
    ...        set the clipboard to "${target_contact}"
    ...        tell application "System Events"
    ...            keystroke "v" using command down
    ...            delay 1
    ...            key code 36  -- 选择联系人
    ...            delay 1
    ...        end tell
    ...    else
    ...        log "DEBUG: 已在目标窗口，无需搜索联系人"
    ...    end if
    ...    
    ...    -- 点击输入区域确保焦点
    ...    tell application "System Events"
    ...        tell process "WeChat"
    ...            set inputPosition to position of front window
    ...            set inputSize to size of front window
    ...            set clickX to inputPosition's item 1 + (inputSize's item 1 div 2)
    ...            set clickY to inputPosition's item 2 + inputSize's item 2 - 100
    ...            click at {clickX, clickY}
    ...        end tell
    ...    end tell
    ...    delay 0.5
    ...    
    ...    -- 输入消息
    ...    set the clipboard to "${custom_message}"
    ...    tell application "System Events"
    ...        keystroke "v" using command down
    ...        delay 0.5
    ...        key code 36  -- 发送消息
    ...    end tell
    
    Create File    ${CURDIR}/wechat_script.applescript    ${applescript}
    记录日志    创建了综合自动化AppleScript文件
    
    ${result5}=    Run Process    osascript    ${CURDIR}/wechat_script.applescript    stderr=STDOUT
    记录日志    综合自动化脚本执行结果: ${result5.stdout}
    记录日志    综合自动化脚本错误输出: ${result5.stderr}

搜索并选择联系人
    [Arguments]    ${target_contact}
    记录日志    开始搜索联系人: "${target_contact}"
    
    # 搜索联系人 (使用Command+F快捷键)
    ${result1}=    Run Process    osascript    -e    tell application "System Events" to keystroke "f" using command down
    记录日志    打开搜索框结果: ${result1.stdout}
    Sleep    0.5s
    
    # 使用剪贴板方法输入联系人名称
    ${clipboard_script}=    Catenate    SEPARATOR=\n
    ...    set the clipboard to "${target_contact}"
    
    ${result2}=    Run Process    osascript    -e    ${clipboard_script}
    记录日志    将联系人名称复制到剪贴板: ${result2.stdout}
    
    # 粘贴联系人名称 (使用Command+V)
    ${result3}=    Run Process    osascript    -e    tell application "System Events" to keystroke "v" using command down
    记录日志    粘贴联系人名称结果: ${result3.stdout}
    
    # 等待搜索结果
    Sleep    1s
    记录日志    等待搜索结果...
    
    # 按回车选择第一个搜索结果
    ${result4}=    Run Process    osascript    -e    tell application "System Events" to key code 36
    记录日志    选择联系人结果: ${result4.stdout}
    
    # 等待聊天窗口加载
    Sleep    1s
    记录日志    聊天窗口加载完成

记录完成信息
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    记录日志    自动化流程完成。结束时间: ${timestamp}
    记录日志    --------------------------------------------------
    
    # 显示日志文件位置
    ${log_path}=    Normalize Path    ${LOG_FILE}
    Log    日志文件已保存至: ${log_path}
    Log To Console    \n日志文件已保存至: ${log_path} 