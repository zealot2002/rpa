on run argv
    set target_contact to item 1 of argv
    
    -- First press ESC to clear any previous state
    tell application "System Events" to key code 53
    delay 0.5
    
    -- Open search with Command+F
    tell application "System Events" to keystroke "f" using command down
    delay 1
    
    -- Set clipboard to contact name and paste it
    set the clipboard to target_contact
    delay 0.3
    
    -- Paste the contact name
    tell application "System Events" to keystroke "v" using command down
    delay 1.5
    
    -- Press Enter to select the first search result
    tell application "System Events" to key code 36
    delay 2
end run