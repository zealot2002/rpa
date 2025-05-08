on run argv
    set message_text to item 1 of argv
    
    tell application "企业微信" to activate
    delay 0.5
    
    tell application "System Events"
        tell process "企业微信"
            -- Get coordinates for input area
            set w to window 1
            set p to position of w
            set s to size of w
            
            -- Click on input area (two different heights for better reliability)
            click at {(item 1 of p) + (item 1 of s)/2, (item 2 of p) + (item 2 of s) - 60}
            delay 0.5
            click at {(item 1 of p) + (item 1 of s)/2, (item 2 of p) + (item 2 of s) - 40}
            delay 0.5
            
            -- Press Tab to ensure focus is in the right place
            keystroke tab
            delay 0.3
            
            -- Clear input area (Select All + Delete)
            keystroke "a" using command down
            delay 0.3
            keystroke (ASCII character 127)  -- Delete key
            delay 0.3
            
            -- Set clipboard content
            set the clipboard to message_text
            delay 0.5
            
            -- Paste content
            keystroke "v" using command down
            delay 0.5
            
            -- Send message
            keystroke return
        end tell
    end tell
end run