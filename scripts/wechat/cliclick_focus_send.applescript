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
    
    -- 直接使用高效率的方法获取焦点
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 1. 高速获取焦点' >> /tmp/wechat_focus_debug.log"
    
    -- 使用精简的双击方式快速获取焦点（保留完整的按下-弹起序列）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.05
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.2
    
    -- 使用单次有效的拖动确保文本焦点（保留完整序列）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick m:" & ((inputX + 5) as integer) & "," & (inputY as integer)
    delay 0.08
    do shell script "cliclick du:" & ((inputX + 5) as integer) & "," & (inputY as integer)
    delay 0.2
    
    tell application "System Events"
        tell process "WeChat"
            -- 简化的输入区激活
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 2. 快速清除区域' >> /tmp/wechat_focus_debug.log"
            
            -- 优先使用键盘方式清除 - 速度最快也最可靠
            keystroke "a" using command down
            delay 0.2
            keystroke (ASCII character 127)  -- 删除键
            delay 0.2
            
            -- 设置剪贴板并粘贴
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 3. 粘贴消息内容' >> /tmp/wechat_focus_debug.log"
            
            -- 使用最可靠的剪贴板设置方式
            do shell script "echo '" & message_text & "' | pbcopy"
            delay 0.3
            
            -- 粘贴命令
            keystroke "v" using command down
            delay 0.5
            
            -- 最后一次确认焦点 - 保持完整序列
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.1
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 4. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.2
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
end run