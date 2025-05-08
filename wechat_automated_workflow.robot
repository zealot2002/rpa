*** Settings ***
Documentation     微信完整自动化流程
...               1. 获取坐标 -> 2. 激活微信 -> 3. 定位输入框 -> 4. 输入内容 -> 5. 发送消息
Library           Process
Library           OperatingSystem
Library           Collections
Library           DateTime

*** Variables ***
${LOG_FILE}       ${CURDIR}/wechat_automation_log.txt
${COORDS_FILE}    ${CURDIR}/wechat_coords.txt

*** Tasks ***
完整微信自动化工作流
    创建日志文件
    获取坐标后自动执行微信操作
    记录完成信息

*** Keywords ***
创建日志文件
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Create File    ${LOG_FILE}    # 微信自动化工作流日志\n# 开始时间: ${timestamp}\n\n

记录日志
    [Arguments]    ${message}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${log_entry}=    Catenate    SEPARATOR=\n    [${timestamp}] ${message}
    Append To File    ${LOG_FILE}    ${log_entry}\n

获取坐标后自动执行微信操作
    记录日志    步骤1: 开始获取微信输入框坐标
    
    # 创建坐标获取脚本
    ${coords_script}=    Catenate    SEPARATOR=\n
    ...    import pyautogui
    ...    import time
    ...    import os
    ...    
    ...    print("鼠标坐标获取工具")
    ...    print("请在5秒内将鼠标移动到微信输入框位置...")
    ...    
    ...    for i in range(5, 0, -1):
    ...        print(f"{i}...")
    ...        time.sleep(1)
    ...    
    ...    # 获取当前鼠标位置
    ...    current_position = pyautogui.position()
    ...    print(f"当前鼠标坐标为: {current_position}")
    ...    print(f"X: {current_position.x}, Y: {current_position.y}")
    ...    
    ...    # 将坐标保存到文件中，以便后续脚本使用
    ...    with open("${COORDS_FILE}", "w") as f:
    ...        f.write(f"{current_position.x},{current_position.y}")
    ...    
    ...    print(f"坐标已保存到文件: {os.path.abspath("${COORDS_FILE}")}")
    
    Create File    ${CURDIR}/get_wechat_coords.py    ${coords_script}
    记录日志    坐标获取脚本已创建
    
    # 运行坐标获取脚本
    ${coords_result}=    Run Process    python    ${CURDIR}/get_wechat_coords.py    stderr=STDOUT    stdout=PIPE
    记录日志    坐标获取脚本输出:\n${coords_result.stdout}
    
    # 检查坐标文件是否存在
    ${coords_exists}=    Run Keyword And Return Status    File Should Exist    ${COORDS_FILE}
    
    # 如果坐标文件存在，读取坐标并执行微信操作
    Run Keyword If    ${coords_exists}    执行微信自动化    ELSE    记录日志    错误: 未能获取坐标，无法继续执行

执行微信自动化
    记录日志    步骤2: 准备执行微信操作
    
    # 读取坐标文件
    ${coords_content}=    Get File    ${COORDS_FILE}
    ${coords}=    Split String    ${coords_content}    ,
    ${x}=    Set Variable    ${coords}[0]
    ${y}=    Set Variable    ${coords}[1]
    
    记录日志    读取到微信输入框坐标: X=${x}, Y=${y}
    
    # 创建微信自动化脚本
    ${wechat_script}=    Catenate    SEPARATOR=\n
    ...    import pyautogui
    ...    import time
    ...    
    ...    # 设置失败安全
    ...    pyautogui.FAILSAFE = True
    ...    
    ...    # 从文件读取坐标
    ...    x, y = ${x}, ${y}
    ...    
    ...    print(f"将使用坐标: X={x}, Y={y}")
    ...    
    ...    # 激活微信窗口
    ...    print("激活微信窗口中...")
    ...    pyautogui.hotkey('command', 'tab')  # 可能需要调整
    ...    time.sleep(1)
    ...    
    ...    # 点击输入框
    ...    print(f"点击输入框位置: ({x}, {y})")
    ...    pyautogui.click(x, y)
    ...    time.sleep(0.5)
    ...    
    ...    # 输入文本
    ...    print("输入文本: 123")
    ...    pyautogui.write('123')
    ...    time.sleep(0.5)
    ...    
    ...    # 发送消息
    ...    print("按回车键发送消息")
    ...    pyautogui.press('enter')
    ...    
    ...    print("微信消息已发送")
    
    Create File    ${CURDIR}/execute_wechat.py    ${wechat_script}
    记录日志    微信操作脚本已创建
    
    # 运行微信操作脚本
    ${wechat_result}=    Run Process    python    ${CURDIR}/execute_wechat.py    stderr=STDOUT    stdout=PIPE
    记录日志    微信操作脚本输出:\n${wechat_result.stdout}

记录完成信息
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    记录日志    自动化流程完成。结束时间: ${timestamp}
    记录日志    --------------------------------------------------
    
    # 显示日志文件位置
    ${log_path}=    Normalize Path    ${LOG_FILE}
    Log    日志文件已保存至: ${log_path}
    Log To Console    \n日志文件已保存至: ${log_path} 