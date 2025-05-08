tell application "WeChat" to activate
delay 1
-- 检查当前是否已在目标联系人的窗口
set isTargetWindow to false
tell application "System Events"
tell process "WeChat"
set windowTitle to name of front window
log "DEBUG: 当前窗口标题: " & windowTitle
log "DEBUG: 目标联系人: 文件传输助手"

-- 首先检查窗口标题
if windowTitle contains "文件传输助手" then
set isTargetWindow to true
end if

-- 如果窗口标题未找到，尝试检查其他UI元素
if not isTargetWindow then
try
set topElements to UI elements of front window
repeat with elem in topElements
try
set elemName to name of elem
log "DEBUG: 检查UI元素: " & elemName
if elemName contains "文件传输助手" then
set isTargetWindow to true
exit repeat
end if
on error
log "DEBUG: 无法检查UI元素"
end try
end repeat
on error
log "DEBUG: 无法获取UI元素"
end try
end if

log "DEBUG: 是否在目标窗口: " & isTargetWindow
end tell
end tell

-- 如果不在目标窗口，则搜索联系人
if not isTargetWindow then
log "DEBUG: 需要搜索联系人"
tell application "System Events"
keystroke "f" using command down
delay 0.5
end tell
set the clipboard to "文件传输助手"
tell application "System Events"
keystroke "v" using command down
delay 1
key code 36
-- 选择联系人
delay 1
end tell
else
log "DEBUG: 已在目标窗口，无需搜索联系人"
end if

-- 点击输入区域确保焦点
tell application "System Events"
tell process "WeChat"
set inputPosition to position of front window
set inputSize to size of front window
set clickX to inputPosition's item 1 + (inputSize's item 1 div 2)
set clickY to inputPosition's item 2 + inputSize's item 2 - 100
click at {clickX, clickY}
end tell
end tell
delay 0.5

-- 输入消息
set the clipboard to "1"
tell application "System Events"
keystroke "v" using command down
delay 0.5
key code 36
-- 发送消息
end tell