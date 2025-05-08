*** Settings ***
Documentation     使用PyAutoGUI进行微信自动化
Library           Process
Library           OperatingSystem

*** Tasks ***
微信发送消息自动化_PyAutoGUI
    # 创建一个Python脚本文件
    ${script}=    Catenate    SEPARATOR=\n
    ...    import pyautogui
    ...    import time
    ...    
    ...    # 设置失败安全，移动鼠标到屏幕角落将中断脚本
    ...    pyautogui.FAILSAFE = True
    ...    
    ...    # 激活微信窗口 (macOS)
    ...    pyautogui.hotkey('command', 'tab')  # 这可能需要调整，取决于您的窗口排列
    ...    time.sleep(0.5)
    ...    
    ...    # 假设微信窗口已经在前台
    ...    # 聚焦到输入框 - 这里我们可以使用点击坐标的方式
    ...    # 以下坐标需要根据您的屏幕分辨率和微信窗口位置进行调整
    ...    
    ...    # 点击输入框位置 (使用实际获取到的坐标)
    ...    pyautogui.click(1266, 746)  # 已更新为获取到的实际坐标
    ...    time.sleep(0.5)
    ...    
    ...    # 输入文本
    ...    pyautogui.write('123')
    ...    
    ...    # 发送消息 (按回车键)
    ...    pyautogui.press('enter')
    ...    
    ...    print("消息已发送")
    
    Create File    ${CURDIR}/wechat_script.py    ${script}
    
    # 运行Python脚本
    ${result}=    Run Process    python    ${CURDIR}/wechat_script.py
    Log    ${result.stdout}
    Log    ${result.stderr} 