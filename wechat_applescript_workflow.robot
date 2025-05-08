*** Settings ***
Documentation     微信完整自动化流程 (AppleScript版本)
...               自动搜索联系人并发送消息
Library           Process
Library           OperatingSystem
Library           Collections
Library           DateTime
Library           String

*** Variables ***
${LOG_FILE}       ${CURDIR}/wechat_applescript_log.txt
${MESSAGE}        123    # 默认消息内容
${CONTACT}        文件传输助手    # 默认联系人
${DEBUG_MODE}     True    # 开启更详细的日志记录
${SCRIPTS_DIR}    ${CURDIR}/scripts/wechat    # 预先创建的脚本目录

*** Tasks ***
完整微信AppleScript自动化工作流
    创建日志文件
    ${scripts_ok}=    检查并安装依赖
    Run Keyword If    ${scripts_ok}    执行基于AppleScript的微信自动化    ${CONTACT}    ${MESSAGE}
    ...    ELSE    Log To Console    \n无法执行自动化：预创建的脚本文件缺失或无执行权限\n
    记录完成信息

*** Keywords ***
检查并安装依赖
    记录日志    检查自动化依赖工具
    
    # 检查cliclick是否已安装
    ${cliclick_installed}=    Run Process    which cliclick    shell=True    stderr=STDOUT
    ${has_cliclick}=    Run Keyword And Return Status    Should Not Be Empty    ${cliclick_installed.stdout}
    
    IF    not ${has_cliclick}
        记录日志    cliclick未安装，推荐使用Homebrew安装此工具以提高鼠标操作的可靠性
        Log To Console    \n推荐安装cliclick工具以提高脚本可靠性: brew install cliclick\n
    ELSE
        记录日志    已安装cliclick工具，可用于备选鼠标操作方案
    END
    
    # 检查脚本文件是否存在
    ${activate_script_exists}=    Run Keyword And Return Status    File Should Exist    ${SCRIPTS_DIR}/activate_wechat.applescript
    ${search_script_exists}=    Run Keyword And Return Status    File Should Exist    ${SCRIPTS_DIR}/search_contact.applescript
    ${send_script_exists}=    Run Keyword And Return Status    File Should Exist    ${SCRIPTS_DIR}/send_message.applescript
    ${cliclick_script_exists}=    Run Keyword And Return Status    File Should Exist    ${SCRIPTS_DIR}/cliclick_focus_send.applescript
    
    ${all_scripts_exist}=    Evaluate    ${activate_script_exists} and ${search_script_exists} and ${send_script_exists} and ${cliclick_script_exists}
    
    # 检查脚本文件权限
    ${scripts_executable}=    Set Variable    ${True}
    IF    ${all_scripts_exist}
        ${activate_perm}=    Run Process    test -x ${SCRIPTS_DIR}/activate_wechat.applescript && echo "OK" || echo "NotExecutable"    shell=True
        ${search_perm}=    Run Process    test -x ${SCRIPTS_DIR}/search_contact.applescript && echo "OK" || echo "NotExecutable"    shell=True
        ${send_perm}=    Run Process    test -x ${SCRIPTS_DIR}/send_message.applescript && echo "OK" || echo "NotExecutable"    shell=True
        ${cliclick_perm}=    Run Process    test -x ${SCRIPTS_DIR}/cliclick_focus_send.applescript && echo "OK" || echo "NotExecutable"    shell=True
        
        ${scripts_executable}=    Evaluate    "${activate_perm.stdout}" == "OK" and "${search_perm.stdout}" == "OK" and "${send_perm.stdout}" == "OK" and "${cliclick_perm.stdout}" == "OK"
        
        IF    not ${scripts_executable}
            记录日志    警告: 某些AppleScript文件没有执行权限，尝试添加执行权限
            Run Process    chmod +x ${SCRIPTS_DIR}/*.applescript    shell=True
            ${scripts_executable}=    Set Variable    ${True}
            记录日志    已添加执行权限至所有脚本文件
        END
    END
    
    ${scripts_ok}=    Evaluate    ${all_scripts_exist} and ${scripts_executable}
    IF    not ${scripts_ok}
        记录日志    错误: 预创建的AppleScript文件不完整或没有执行权限
        Log To Console    \n错误: 预创建的AppleScript文件不完整或没有执行权限，请确保所有脚本文件已正确创建在 ${SCRIPTS_DIR} 目录下\n
    ELSE
        记录日志    验证完成: 所有预创建的AppleScript文件都已存在且有执行权限
    END
    
    RETURN    ${scripts_ok}
    
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
    
    # 激活微信窗口 - 使用预创建的脚本
    ${result1}=    Run Process    osascript    ${SCRIPTS_DIR}/activate_wechat.applescript    stderr=STDOUT
    ${wechat_activated}=    Run Keyword And Return Status    Should Be Empty    ${result1.stderr}
    
    IF    not ${wechat_activated}
        记录日志    错误: 无法激活微信窗口: ${result1.stderr}
        Log To Console    \n错误: 无法激活微信窗口，请确认微信已安装并且可以手动启动\n
        RETURN    ${False}
    END
    
    记录日志    AppleScript激活微信窗口结果: ${result1.stdout}
    
    # 等待窗口激活
    Sleep    1s
    记录日志    步骤2: 等待窗口激活完成
    
    # 直接搜索联系人 - 使用预创建的脚本
    记录日志    步骤3: 使用预创建脚本搜索联系人 "${target_contact}"
    ${result2}=    Run Process    osascript    ${SCRIPTS_DIR}/search_contact.applescript    ${target_contact}    stderr=STDOUT
    ${contact_found}=    Run Keyword And Return Status    Should Be Empty    ${result2.stderr}
    
    IF    not ${contact_found}
        记录日志    错误: 搜索联系人失败: ${result2.stderr}
        Log To Console    \n错误: 无法搜索或找到联系人 "${target_contact}"\n
        RETURN    ${False}
    END
    
    记录日志    搜索联系人脚本执行结果: ${result2.stdout}
    
    # 等待聊天窗口加载完成
    Sleep    0.1s
    记录日志    步骤4: 聊天窗口已加载，准备输入消息

    # 检查是否安装了cliclick工具，优先使用cliclick
    记录日志    检查是否可以使用cliclick工具
    ${cliclick_check}=    Run Process    which cliclick    shell=true
    ${has_cliclick}=    Run Keyword And Return Status    Should Not Be Empty    ${cliclick_check.stdout}
    
    ${send_success}=    Set Variable    ${False}
    IF    ${has_cliclick}
        记录日志    找到cliclick工具，使用增强型cliclick专用脚本发送消息 (使用多种获取焦点方法)
        
        # 使用cliclick专用脚本
        记录日志    执行增强型焦点获取脚本 (使用多种点击方法和位置，模拟更真实的用户行为)
        ${result3}=    Run Process    osascript    ${SCRIPTS_DIR}/cliclick_focus_send.applescript    ${custom_message}    stderr=STDOUT
        ${send_success}=    Run Keyword And Return Status    Should Be Empty    ${result3.stderr}
        
        记录日志    cliclick专用脚本执行结果: ${result3.stdout}
        IF    ${send_success}
            记录日志    使用增强型cliclick获取焦点机制后通过AppleScript完成消息发送
            RETURN    ${True}
        ELSE
            记录日志    警告: 增强型cliclick脚本执行出现错误: ${result3.stderr}
            记录日志    尝试使用纯AppleScript方案作为备选
        END
    ELSE
        记录日志    未找到cliclick工具，使用纯AppleScript方案
    END
    
    # 使用纯AppleScript方案 - 使用预创建的脚本
    记录日志    尝试使用纯AppleScript方案发送消息
    ${result4}=    Run Process    osascript    ${SCRIPTS_DIR}/send_message.applescript    ${custom_message}    stderr=STDOUT
    ${send_success}=    Run Keyword And Return Status    Should Be Empty    ${result4.stderr}
    
    IF    ${send_success}
        记录日志    纯AppleScript消息发送脚本执行结果: ${result4.stdout}
        记录日志    消息发送完成
        RETURN    ${True}
    ELSE
        记录日志    错误: 所有消息发送方法都失败: ${result4.stderr}
        Log To Console    \n错误: 无法发送消息，请检查微信窗口状态\n
        记录日志    提示: 如果消息能发送但内容不显示，可能是焦点问题，尝试以下解决方法:
        记录日志    1. 确保微信窗口处于前台活动状态
        记录日志    2. 检查屏幕分辨率与脚本中的点击坐标匹配
        记录日志    3. 尝试使用较慢的执行速度 (使用 --variable SLOW:True 参数运行)
        记录日志    4. 手动编辑cliclick_focus_send.applescript，调整点击坐标
        RETURN    ${False}
    END

搜索并选择联系人
    [Arguments]    ${target_contact}
    记录日志    已移除此关键字，现在直接使用预创建的 search_contact.applescript 脚本

记录完成信息
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    记录日志    自动化流程完成。结束时间: ${timestamp}
    记录日志    --------------------------------------------------
    
    # 显示日志文件位置
    ${log_path}=    Normalize Path    ${LOG_FILE}
    Log    日志文件已保存至: ${log_path}
    Log To Console    \n日志文件已保存至: ${log_path} 