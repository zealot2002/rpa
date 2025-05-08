on run argv
    -- 记录开始时间
    set startTime to current date
    set startTimeString to ((time string of startTime) as string)
    log "=== 脚本开始执行时间: " & startTimeString & " ==="
    
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 0.2  -- 减少延迟，确保窗口完全激活
    
    tell application "System Events"
        tell process "WeChat"
            -- 获取窗口信息
            set w to window 1
            set p to position of w
            set s to size of w
            
            -- 直接计算右下角输入框区域的坐标
            set inputX to (item 1 of p) + (item 1 of s) - 150  -- 右侧偏左约150像素
            set inputY to (item 2 of p) + (item 2 of s) - 40   -- 底部上方约40像素
            
        end tell
    end tell
    
    tell application "System Events"
        tell process "WeChat"
            -- 先按Escape确保没有弹出菜单干扰
            key code 53  -- Esc键
            delay 0.1
            
            -- 点击右键再点击左键，使用完整的按下-弹起序列
            do shell script "cliclick rc:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.1
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.1
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.1
            
            -- 先通过命令行设置剪贴板内容（更可靠）
            do shell script "echo '" & message_text & "' | pbcopy"
            delay 0.2
            
            -- 粘贴尝试1：使用AppleScript的剪贴板
            set the clipboard to message_text
            delay 0.2
            
            -- 粘贴尝试2：粘贴命令
            keystroke "v" using command down
            delay 0.2  -- 增加延迟确保粘贴完成
            
            -- 再次点击确保焦点，防止粘贴后焦点丢失 - 使用完整的按下-弹起序列
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 5. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.1
            
            -- 确保发送成功（有时第一次return可能无效）
            keystroke return
            delay 0.1
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
    
    -- 计算并打印执行时间
    set endTime to current date
    set endTimeString to ((time string of endTime) as string)
    
    -- 计算执行时间（秒）
    set executionSeconds to endTime - startTime
    
    -- 格式化为分钟和秒
    set executionMinutes to executionSeconds div 60
    set remainingSeconds to executionSeconds mod 60
    
    -- 打印执行时间统计到控制台
    log "=== 脚本执行统计 ==="
    log "开始时间: " & startTimeString
    log "结束时间: " & endTimeString
    log "总执行时间: " & executionMinutes & "分 " & remainingSeconds & "秒 (共" & executionSeconds & "秒)"
    log "=================="
end run