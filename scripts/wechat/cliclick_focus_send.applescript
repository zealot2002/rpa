on run argv
    set message_text to item 1 of argv
    
    tell application "WeChat" to activate
    delay 0.5
    
    -- Use cliclick for more reliable focusing
    do shell script "cliclick c:800,700"
    delay 0.3
    do shell script "cliclick c:800,680"
    delay 0.5
    
    tell application "System Events"
        tell process "WeChat"
            -- Ensure focus with tab key
            keystroke tab
            delay 0.3
            
            -- Clear input area
            keystroke "a" using command down
            delay 0.3
            keystroke (ASCII character 127)
            delay 0.3
            
            -- Set clipboard and paste content
            set the clipboard to message_text
            delay 0.5
            keystroke "v" using command down
            delay 0.5
            
            -- Send message
            keystroke return
        end tell
    end tell
end run