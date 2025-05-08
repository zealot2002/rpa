*** Settings ***
Documentation     基于图像的桌面自动化示例
Library           RPA.Desktop

*** Tasks ***
基于图像识别操作桌面
    # 截图作为参考
    Take Screenshot
    
    # 点击桌面上的图标（需要先准备图标截图）
    # Click    image:path/to/icon.png
    
    # 模拟在某个位置点击
    Click    coordinates:100,100
    
    # 模拟键盘输入
    Press Keys    Hello World
    
    # 模拟组合键
    Press Keys    ctrl    a
    Press Keys    ctrl    c 