on run argv
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 0.5  -- 减少延迟时间
    
    -- 记录日志
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 开始执行高速版焦点获取脚本' >> /tmp/wechat_focus_debug.log"
    
    tell application "System Events"
        tell process "WeChat"
            -- 获取窗口信息
            set w to window 1
            set p to position of w
            set s to size of w
            
            -- 直接计算右下角输入框区域的坐标
            set inputX to (item 1 of p) + (item 1 of s) - 150  -- 右侧偏左约150像素
            set inputY to (item 2 of p) + (item 2 of s) - 40   -- 底部上方约40像素
            
            -- 记录计算的坐标
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 右下角输入区域: " & inputX & "," & inputY & "' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
    
    -- 首先确保窗口处于前台并获得焦点
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 1. 精确获取焦点' >> /tmp/wechat_focus_debug.log"
    
    -- 确保窗口处于激活状态 - 使用简单点击
    do shell script "cliclick c:400,400" -- 点击窗口中央区域，确保窗口处于前台
    delay 0.2
    
    -- 有效焦点获取组合1：按下-弹起-按下-弹起(双击) + 拖动
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.2
    
    -- 有效焦点获取组合2：尝试不同位置点击
    -- 输入区域正中央
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.2
    
    -- 尝试右下角
    set rightX to (item 1 of p) + (item 1 of s) - 80
    set rightY to (item 2 of p) + (item 2 of s) - 30
    do shell script "cliclick dd:" & (rightX as integer) & "," & (rightY as integer)
    delay 0.08
    do shell script "cliclick du:" & (rightX as integer) & "," & (rightY as integer)
    delay 0.2
    
    tell application "System Events"
        tell process "WeChat"
            -- 键盘焦点获取与激活
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 2. 键盘激活输入区' >> /tmp/wechat_focus_debug.log"
            
            -- 这些键盘操作对焦点获取至关重要
            -- 先按Tab键，非常关键的焦点切换步骤
            keystroke tab
            delay 0.15
            
            -- 输入/删除点，强制激活输入区域
            keystroke "."
            delay 0.1
            keystroke (ASCII character 127)  -- 删除键
            delay 0.15
            
            -- 清除输入区域 - 全选和删除
            keystroke "a" using command down
            delay 0.15
            keystroke (ASCII character 127)  -- 删除键
            delay 0.15
            
            -- 设置剪贴板并粘贴
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 3. 粘贴消息内容' >> /tmp/wechat_focus_debug.log"
            
            -- 设置剪贴板
            do shell script "echo '" & message_text & "' | pbcopy"
            delay 0.2
            
            -- 粘贴命令前再次点击
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.08
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.15
            
            -- 执行粘贴
            keystroke "v" using command down
            delay 0.4
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 4. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.2
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
end run