on run argv
    -- 记录开始时间
    set startTime to current date
    set startTimeString to ((time string of startTime) as string)
    log "=== 脚本开始执行时间: " & startTimeString & " ==="
    
    -- 获取消息文本
    set message_text to item 1 of argv
    
    -- 直接设置企业微信应用信息
    set app_name to "企业微信"
    set process_name to "企业微信"
    set dock_name to "企业微信"
    set input_x_offset to 150
    set input_y_offset to 40
    set helper_process to "企业微信 Helper"
    
    log "目标应用: " & app_name & " (进程名: " & process_name & ")"
    
    -- 特殊处理应用激活，确保即使最小化也能回到前台
    tell application "System Events"
        -- 先结束任何可能已经运行但卡住的Helper进程
        try
            do shell script "killall '" & helper_process & "' 2>/dev/null || true"
        end try
        delay 0.1
    end tell
    
    -- 通过多种方式激活应用
    tell application app_name to activate
    delay 0.3
    
    -- 如果应用窗口被最小化了，尝试点击Dock图标
    tell application "System Events"
        try
            tell process "Dock"
                click UI element dock_name of list 1
            end tell
            delay 0.3
        end try
    end tell
    
    -- 再次确保应用激活
    tell application app_name to activate
    delay 0.3
    
    tell application "System Events"
        tell process process_name
            -- 获取窗口信息
            set w to window 1
            set p to position of w
            set s to size of w
            
            -- 直接计算右下角输入框区域的坐标
            set inputX to (item 1 of p) + (item 1 of s) - (input_x_offset as integer)
            set inputY to (item 2 of p) + (item 2 of s) - (input_y_offset as integer)
            
        end tell
    end tell
    
    tell application "System Events"
        tell process process_name
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
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 5. 发送消息 (应用: " & app_name & ")' >> /tmp/wechat_focus_debug.log"
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
    log "目标应用: " & app_name
    log "开始时间: " & startTimeString
    log "结束时间: " & endTimeString
    log "总执行时间: " & executionMinutes & "分 " & remainingSeconds & "秒 (共" & executionSeconds & "秒)"
    log "=================="
end run