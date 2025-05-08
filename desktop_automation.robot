*** Settings ***
Documentation     桌面自动化示例
Library           RPA.Desktop
Library           RPA.Windows

*** Tasks ***
操作桌面窗口
    # 打开记事本
    Windows Run    notepad.exe
    # 等待记事本窗口出现
    Control Window    Untitled - Notepad
    # 输入文本
    Send Keys    Hello, Robot Framework!
    # 截图
    Take Screenshot
    # 关闭记事本 (Alt+F4)
    Send Keys    {Alt}F4
    # 不保存
    Control Window    Notepad
    Click    Don't Save