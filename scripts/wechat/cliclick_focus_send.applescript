on run argv
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 1.5  -- 增加延迟，确保窗口完全激活
    
    -- 记录日志
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 开始执行增强型焦点获取脚本' >> /tmp/wechat_focus_debug.log"
    
    tell application "System Events"
        tell process "WeChat"
            -- 获取窗口信息
            set w to window 1
            set p to position of w
            set s to size of w
            
            -- 记录窗口信息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 窗口位置: " & p & ", 大小: " & s & "' >> /tmp/wechat_focus_debug.log"

            -- 直接计算右下角输入框区域的坐标（更保守的方法）
            -- 微信输入框通常在窗口右下角
            set inputX to (item 1 of p) + (item 1 of s) - 150  -- 右侧偏左约150像素
            set inputY to (item 2 of p) + (item 2 of s) - 40   -- 底部上方约40像素
            
            -- 计算右下角区域的点击位置数组（更精确的多点位置）
            set rightBottom to {inputX, inputY}
            set rightBottomRight to {inputX + 50, inputY}
            set rightBottomLeft to {inputX - 30, inputY}
            set rightBottomUp to {inputX, inputY - 20}
            
            -- 记录计算的坐标
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 右下角输入区域: " & inputX & "," & inputY & "' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
    
    -- 先确保窗口置顶（直接点击右下角区域，避免点击左侧联系人列表）
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 1. 点击窗口右下角区域获取窗口焦点' >> /tmp/wechat_focus_debug.log"
    
    -- 使用完整的点击事件（按下+释放）确保窗口获得焦点
    do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
    delay 0.3
    do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
    delay 1.0
    
    -- 执行从右下角开始的焦点获取流程
    do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 2. 执行增强型点击序列，真实模拟完整鼠标事件' >> /tmp/wechat_focus_debug.log"
    
    -- 创建闪烁效果并逐步尝试由外向内的位置
    repeat 3 times
        -- 使用三连击方法（有些应用需要双击或三连击才能获取文本编辑焦点）
        -- 中心位置的完整三连击
        do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.15
        do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.1
        do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.15
        do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.1
        do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.15
        do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.7
        
        -- 再在周边点击，精确模拟完整的按下和释放事件
        -- 右侧点击
        do shell script "cliclick dd:" & ((inputX + 50) as integer) & "," & (inputY as integer)
        delay 0.3  -- 长按一段时间
        do shell script "cliclick du:" & ((inputX + 50) as integer) & "," & (inputY as integer)
        delay 0.4
        
        -- 左侧点击（但不要太靠左以免点到联系人列表）
        do shell script "cliclick dd:" & ((inputX - 30) as integer) & "," & (inputY as integer)
        delay 0.3  -- 长按一段时间
        do shell script "cliclick du:" & ((inputX - 30) as integer) & "," & (inputY as integer)
        delay 0.4
        
        -- 上方点击
        do shell script "cliclick dd:" & (inputX as integer) & "," & ((inputY - 20) as integer)
        delay 0.3  -- 长按一段时间
        do shell script "cliclick du:" & (inputX as integer) & "," & ((inputY - 20) as integer)
        delay 0.4
        
        -- 尝试慢速拖动操作以激活文本编辑区域
        do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
        delay 0.2
        do shell script "cliclick m:" & ((inputX + 10) as integer) & "," & (inputY as integer)
        delay 0.2
        do shell script "cliclick du:" & ((inputX + 10) as integer) & "," & (inputY as integer)
        delay 0.6
    end repeat
    
    tell application "System Events"
        tell process "WeChat"
            -- 使用键盘控制尝试获得焦点
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 3. 使用增强型键盘控制尝试获得焦点' >> /tmp/wechat_focus_debug.log"
            
            -- 按Esc先清除任何可能的弹出状态
            key code 53  -- Esc键
            delay 0.5
            
            -- 避免点击左侧联系人，按下右箭头键聚焦在右侧聊天区域
            key code 124  -- 右箭头键
            delay 0.5
            
            -- 按下几次Tab键，尝试循环到输入框
            repeat 2 times
                keystroke tab
                delay 0.4
            end repeat
            
            -- 按几次下箭头，尝试到达底部
            repeat 3 times
                key code 125  -- 下箭头键
                delay 0.3
            end repeat
            
            -- 最后再次模拟点击输入区域中心，确保光标真正显示
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.5
            
            -- 尝试特殊的输入焦点获取
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 4. 使用特殊字符和模拟拖选激活输入区域' >> /tmp/wechat_focus_debug.log"
            
            -- 创建增强型输入闪烁效果
            repeat 2 times
                -- 尝试输入一个空格再删除它，强制激活输入区域
                keystroke space
                delay 0.3
                keystroke (ASCII character 127)  -- 删除键
                delay 0.3
                
                -- 输入句号并删除，产生更明显的闪烁效果
                keystroke "."
                delay 0.5
                keystroke (ASCII character 127)  -- 删除键
                delay 0.5
            end repeat
            
            -- 尝试点击右键再点击左键
            do shell script "cliclick rc:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.7
            do shell script "cliclick c:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.5
            
            -- 如果有文本，清除输入区域
            keystroke "a" using command down
            delay 0.5
            keystroke (ASCII character 127)
            delay 0.7
            
            -- 再次确认焦点
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.3
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.5
            
            -- 设置剪贴板内容
            set the clipboard to message_text
            delay 0.8
            
            -- 粘贴内容
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 5. 粘贴消息内容' >> /tmp/wechat_focus_debug.log"
            keystroke "v" using command down
            delay 1.2  -- 充分延迟，确保内容粘贴完成
            
            -- 发送消息前再次确认焦点
            do shell script "cliclick dd:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.2
            do shell script "cliclick du:" & (inputX as integer) & "," & (inputY as integer)
            delay 0.5
            
            -- 发送消息
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 6. 发送消息' >> /tmp/wechat_focus_debug.log"
            keystroke return
            delay 0.7
            
            -- 记录完成
            do shell script "echo '[$(date +\"%Y-%m-%d %H:%M:%S\")] 脚本执行完成' >> /tmp/wechat_focus_debug.log"
        end tell
    end tell
end run