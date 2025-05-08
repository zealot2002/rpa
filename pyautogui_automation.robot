*** Settings ***
Documentation     使用PyAutoGUI进行桌面自动化
Library           Process
Library           OperatingSystem

*** Tasks ***
使用PyAutoGUI操作桌面
    # 创建一个Python脚本文件
    ${script}=    Catenate    SEPARATOR=\n
    ...    import pyautogui
    ...    import time
    ...    
    ...    # 设置失败安全，移动鼠标到屏幕角落将中断脚本
    ...    pyautogui.FAILSAFE = True
    ...    
    ...    # 获取屏幕分辨率
    ...    print(f"屏幕分辨率: {pyautogui.size()}")
    ...    
    ...    # 打开应用 (在macOS上打开Safari)
    ...    pyautogui.hotkey('command', 'space')
    ...    time.sleep(0.5)
    ...    pyautogui.write('Safari')
    ...    pyautogui.press('return')
    ...    time.sleep(1)
    ...    
    ...    # 在地址栏中输入URL
    ...    pyautogui.hotkey('command', 'l')
    ...    pyautogui.write('www.example.com')
    ...    pyautogui.press('return')
    ...    time.sleep(2)
    ...    
    ...    # 截图
    ...    screenshot = pyautogui.screenshot()
    ...    screenshot.save('screen.png')
    ...    print("屏幕截图已保存为 screen.png")
    
    Create File    ${CURDIR}/auto_script.py    ${script}
    
    # 运行Python脚本
    ${result}=    Run Process    python    ${CURDIR}/auto_script.py
    Log    ${result.stdout}
    Log    ${result.stderr} 