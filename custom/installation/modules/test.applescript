--tell application "iTerm"
--    set desiredPresetName to "custom"
--
--    set desiredCommand to "echo -e '\\033]50;SetProfile=" & desiredPresetName & "\\a'"
--    tell current session of current window
--    write text desiredCommand
--    end tell
--end tell



--tell application "iTerm"
--    set desiredPresetName to "custom"
--
--    -- Get the list of available profiles
--    set profileList to the name of every profile
--
--    -- Check if the desired profile exists
--    if desiredPresetName is in profileList then
--        -- Set the desired profile as the active profile
--        set desiredProfile to (first profile where its name is desiredPresetName)
--        set current settings of current session of current window to desiredProfile
--    else
--        display dialog "The desired profile does not exist."
--    end if
--end tell




tell application "iTerm"
set desiredPresetName to "custom"

set desiredProfile to (first profile where its name is desiredPresetName)

tell current session of current window
set current settings to desiredProfile
end tell
end tell
