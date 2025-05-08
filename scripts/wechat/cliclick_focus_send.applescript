on run argv
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 0.8  -- 减少延迟时间
    
    -- 记录日志
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 开始执行优化版焦点获取脚本' >> /tmp/wechat_focus_debug.log"
    
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
    
    -- 直接点击右下角区域获取焦点
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 1. 高效点击右下角区域获取焦点' >> /tmp/wechat_focus_debug.log"
    
    -- 直接使用双击获取焦点（按下-释放-按下-释放）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.2
    
    -- 使用拖动操作确保文本框获得焦点（单次有效的拖动比多次点击更可靠）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick m:" & ((inputX + 10) as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & ((inputX + 10) as integer) & "," & (inputY as integer)
    delay 0.3
    
    tell application "System Events"
        tell process "WeChat"
            -- 使用键盘激活输入区域（保留最有效的部分）
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 2. 高效键盘激活' >> /tmp/wechat_focus_debug.log"
            
            -- 只按一次Tab键
            keystroke tab
            delay 0.2
            
            -- 输入并删除字符，快速激活光标
            keystroke "."
            delay 0.2
            keystroke (ASCII character 127)  -- 删除键
            delay 0.2
            
            -- 清除输入区域
            keystroke "a" using command down
            delay 0.2
            keystroke (ASCII character 127)
            delay 0.3
            
            -- 设置剪贴板内容并粘贴
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 3. 粘贴消息内容' >> /tmp/wechat_focus_debug.log"
            set the clipboard to message_text
            delay 0.3
            
            keystroke "v" using command down
            delay 0.5
            
            -- 最后确认一次焦点并发送
            do shell script "cliclick c:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 4. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.3
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
end run