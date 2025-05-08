on run argv
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 0.8  -- 减少延迟，确保窗口完全激活
    
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
    
    -- 先点击一次确保窗口处于激活状态 - 使用完整按下弹起
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.2
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.3
    
    -- 使用双击获取焦点（按下-释放-按下-释放）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.3
    
    -- 使用拖动操作确保文本框获得焦点（单次有效的拖动比多次点击更可靠）
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick m:" & ((inputX + 10) as integer) & "," & (inputY as integer)
    delay 0.1
    do shell script "cliclick du:" & ((inputX + 10) as integer) & "," & (inputY as integer)
    delay 0.4
    
    tell application "System Events"
        tell process "WeChat"
            -- 使用键盘激活输入区域（保留最有效的部分）
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 2. 高效键盘激活' >> /tmp/wechat_focus_debug.log"
            
            -- 先按Escape确保没有弹出菜单干扰
            key code 53  -- Esc键
            delay 0.2
            
            -- 按一次Tab键
            keystroke tab
            delay 0.3
            
            -- 三次输入删除循环，确保输入区域被激活
            repeat 2 times
                -- 输入并删除字符，确保光标激活并闪烁
                keystroke "."
                delay 0.2
                keystroke (ASCII character 127)  -- 删除键
                delay 0.2
            end repeat
            
            -- 点击右键再点击左键，使用完整的按下-弹起序列
            do shell script "cliclick rc:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            
            -- 清除输入区域 - 使用两种方式确保清除成功
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 3. 清除并准备粘贴' >> /tmp/wechat_focus_debug.log"
            
            -- 方式1: Cmd+A 全选
            keystroke "a" using command down
            delay 0.4
            keystroke (ASCII character 127)  -- 删除键
            delay 0.4
            
            -- 再次确认焦点，使用完整的按下-弹起序列
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            
            -- 设置剪贴板内容并粘贴
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 4. 粘贴消息内容' >> /tmp/wechat_focus_debug.log"
            
            -- 先通过命令行设置剪贴板内容（更可靠）
            do shell script "echo '" & message_text & "' | pbcopy"
            delay 0.5
            
            -- 粘贴尝试1：使用AppleScript的剪贴板
            set the clipboard to message_text
            delay 0.5
            
            -- 粘贴尝试2：粘贴命令
            keystroke "v" using command down
            delay 0.8  -- 增加延迟确保粘贴完成
            
            -- 再次点击确保焦点，防止粘贴后焦点丢失 - 使用完整的按下-弹起序列
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            
            -- 模拟光标闪烁效果，增强光标可见性
            keystroke space
            delay 0.2
            keystroke (ASCII character 127)  -- 删除键
            delay 0.2
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 5. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.3
            
            -- 确保发送成功（有时第一次return可能无效）
            keystroke return
            delay 0.2
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
end run