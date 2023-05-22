#!/bin/bash

install_test() {
    # Enable AppleScript support in iTerm2
    defaults write com.googlecode.iterm2 "NSAppleScriptEnabled" -bool true

    # AppleScript code to set the color scheme
    osascript <<EOF
tell application "iTerm"
    set desiredPresetName to "custom"

    set desiredCommand to "echo -e '\\033]50;SetProfile=" & desiredPresetName & "\\a'"
    tell current session of current window
        write text desiredCommand
    end tell
end tell
EOF
}
