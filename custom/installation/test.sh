#!/usr/bin/env bash

#todo FIRST : iterm color settings doesnt work in manual install

#todo FIRST : split up Xtools and brew, then, as 3rth...when installing X, call those 2 also


#todo install warp test
#todo install iterm2 test
#todo check variables and documnettaion urrl
#todo add reamMe with documentation
##TODO: install with brew  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

##TODO: Add jetbrains config?
##TODO: Add tree command?
##TODO: suggest keyrepeat
##TODO: Add homebrew command?



ZSH_INSTALL="$ZSH/custom/installation"

###########
# IMPORTS #
###########
chmod 755 "$ZSH_INSTALL"/config/variables.sh && source "$ZSH_INSTALL"/config/variables.sh
chmod 755 "$ZSH_INSTALL"/config/functions.sh && source "$ZSH_INSTALL"/config/functions.sh
chmod 755 "$ZSH_INSTALL"/config/messages.sh && source "$ZSH_INSTALL"/config/messages.sh
chmod 755 "$ZSH_INSTALL"/config/modules.sh && source "$ZSH_INSTALL"/config/modules.sh

init() {
  if $MOD_TEST; then chmod 755 "$ZSH_INSTALL"/modules/test.sh && source "$ZSH_INSTALL"/modules/test.sh; fi
  if $MOD_ZSH; then chmod 755 "$ZSH_INSTALL"/modules/zsh.sh && source "$ZSH_INSTALL"/modules/zsh.sh; fi
  if $MOD_FONTS; then chmod 755 "$ZSH_INSTALL"/modules/fonts.sh && source "$ZSH_INSTALL"/modules/fonts.sh; fi
  if $MOD_ITERM; then chmod 755 "$ZSH_INSTALL"/modules/iterm.sh && source "$ZSH_INSTALL"/modules/iterm.sh; fi
  if $MOD_THEMES; then chmod 755 "$ZSH_INSTALL"/modules/themes.sh && source "$ZSH_INSTALL"/modules/themes.sh; fi
  if $MOD_WARP; then chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh; fi
  if $MOD_ZSHRC; then chmod 755 "$ZSH_INSTALL"/modules/zshrc.sh && source "$ZSH_INSTALL"/modules/zshrc.sh; fi
  if $MOD_PYENV; then chmod 755 "$ZSH_INSTALL"/modules/pyenv.sh && source "$ZSH_INSTALL"/modules/pyenv.sh; fi
    chmod 755 "$ZSH_INSTALL"/modules/iterm-import-scheme.sh && source "$ZSH_INSTALL"/modules/iterm-import-scheme.sh;
    chmod 755 "$ZSH_INSTALL"/modules/iterm-set-color-preset-with-applescript.sh && source "$ZSH_INSTALL"/modules/iterm-set-color-preset-with-applescript.sh;
#    chmod 755 "$ZSH_INSTALL"/modules/dd.scpt
#    chmod 755 "$ZSH_INSTALL"/modules/test.applescript
}
init




#color_preset_path="$ZSH/Desktop/Custom.itermcolors"
color_preset_path="$HOME/Desktop/custom.plist"
color_preset_name="Custom"
iterm2_plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

set_color_preset_in_plist(){

# Import the color scheme using the open command in the background
(open "$color_preset_path" &)

# Wait for a short period to ensure the color scheme is imported
sleep 1

# Get the UUID of the imported color scheme
color_scheme_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v scheme="$color_preset_name" -F" = " '$2 == "\""scheme"\"" { print $1 }')

# Set the imported color scheme as the default
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$color_scheme_uuid"
}


profile_name="Default"
import_continued(){
echo '------ import_continued START'
  custom_plist="$HOME/Desktop/custom.plist"
  color_preset_name="Custom"

# Create the Color Presets entry if it doesn't exist
/usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Color Presets':'$color_preset_name' 'dict'" "$custom_plist"

  # Extract color preset values from custom.plist
  color_preset_values=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Color Presets':'$color_preset_name'" "$custom_plist")

  # Add color preset to iTerm2 preferences file
  defaults write "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "Custom Color Presets:$color_preset_name" "$color_preset_values"
echo '------ import_continued END'
}
#import_continued

axel(){

# Get the UUID of the imported color preset
color_preset_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v preset="$color_preset_name" -F" = " '$2 == "\""preset"\"" { print $1 }')

# Activate the imported color preset
defaults write com.googlecode.iterm2 "New Bookmarks:0:Custom Color Presets:Default" -string "$color_preset_uuid"

#/usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Custom Color Presets':'$color_preset_uuid'" "$iterm2_plist"
/usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Custom Color Presets':'$color_preset_uuid'" "$iterm2_plist"
defaults read com.googlecode.iterm2 "New Bookmarks:0:Custom Color Presets:Default" -string "$color_preset_uuid"
checkhere=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v preset="$color_preset_name" -F" = " '$2 == "\""preset"\"" { print $1 }')
echo "$chxeckhere"
}
axel


set_color_preset() {

#  bookmark_color_preset=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Custom Color Presets'" "$iterm2_plist")
#echo $bookmark_color_preset
#
#  if string_contains_substring "$bookmark_color_preset" "MesloLGS" ]; then
#    msg_found "Installed"
#  else
#    msg_not_found "Not installed"
#  fi

#todo original of font
#    msg_searching "Configuring iterm font and fontsize"
#    #maybe not needed, doesn't need the defaults
#    defaults write com.googlecode.iterm2 "Normal Font" -string "$meslo_font_name"
#    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font' '$meslo_font_name'" "$iterm2_plist"
#    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font Size' $meslo_font_size" "$iterm2_plist"
#    msg_found "Configured"

  echo '---testing---'
    bookmark_normal_font=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Custom Color Presets'" "$iterm2_plist")
  echo "$bookmark_normal_font"



  echo '---using defaults'
# Get the UUID of the imported color preset
#color_preset_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v preset="$color_preset_name" -F" = " '$2 == "\""preset"\"" { print $1 }')

# Activate the imported color preset using defaults
#defaults write com.googlecode.iterm2 "New Bookmarks:0:'Custom Color Presets':'Default'" -string "$color_preset_uuid"




  echo '--using PlistBuddy'
# Get the UUID of the imported color preset
color_preset_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v preset="$color_preset_name" -F" = " '$2 == "\""preset"\"" { print $1 }')

# Set the imported color preset as the default
/usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Custom Color Presets':'Default' $color_preset_uuid" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"




      #defaults write com.googlecode.iterm2 "Custom Color Presets" -string "$color_preset_name"



# Set the imported color preset as the default
#defaults write com.googlecode.iterm2 "Default Color Preset" -string "$color_preset_uuid"




echo "SET --- SEEMS OK HERE"
# Set the color preset for a profile in iTerm2 preferences plist file
#/usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Custom Color Presets':'$profile_name' string '$color_preset_name'" "$iterm2_plist"





#todo this is close
# Get the UUID of the imported color preset
#color_preset_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v preset="$color_preset_name" -F" = " '$2 == "\""preset"\"" { print $1 }')

# Activate the imported color preset
#defaults write com.googlecode.iterm2 "New Bookmarks:0:Custom Color Presets:Default" -string "$color_preset_uuid"

#/usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Custom Color Presets':'$color_preset_uuid'" "$iterm2_plist"
}

#import_color_preset
#set_color_preset




#TODO : Double check that font + size can be set correctly
otherwise() {
  iterm2_plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  meslo_font_name="Meslo"
  font_size="12.0"

  # Check if 'Normal Font' exists
  existing_font=$( /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Normal Font'" "$iterm2_plist" 2>/dev/null )

  if [[ -z "$existing_font" ]]; then
    # 'Normal Font' doesn't exist, use 'Add' command
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Normal Font' dict" "$iterm2_plist"
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Normal Font':'Name' string '$meslo_font_name'" "$iterm2_plist"
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Normal Font':'Size' real $font_size" "$iterm2_plist"
  else
    # 'Normal Font' already exists, use 'Set' command
    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font':'Name' '$meslo_font_name'" "$iterm2_plist"
    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font':'Size' $font_size" "$iterm2_plist"
  fi
 # In this updated script, we capture the output of Print :'New Bookmarks':0:'Normal Font' in the existing_font variable. If the variable is empty (-z check), it means the property doesn't exist, and we use the Add command to create it. Otherwise, we use the Set command to update the existing property.

#Please give it a try and let me know if it works for you.

}

tt (){
# Check if 'Custom Color Presets' exists
#existing_presets=$( /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Custom Color Presets'" "$iterm2_plist" 2>/dev/null )
#
#if [[ -z "$existing_presets" ]]; then
#  # 'Custom Color Presets' doesn't exist, use 'Add' command
#  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Custom Color Presets' dict" "$iterm2_plist"
#  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Custom Color Presets':'Default' string '$color_preset_name'" "$iterm2_plist"
#else
#  # 'Custom Color Presets' already exists, use 'Set' command
#  /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Custom Color Presets':'Default' '$color_preset_name'" "$iterm2_plist"
#fi



# Check if 'Color Presets' exists
existing_presets=$( /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Color Presets'" "$iterm2_plist" 2>/dev/null )

if [[ -z "$existing_presets" ]]; then
  # 'Color Presets' doesn't exist, use 'Add' command
  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Color Presets' dict" "$iterm2_plist"
  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Color Presets':'$color_preset_name' dict" "$iterm2_plist"
else
  # 'Color Presets' already exists, use 'Add' or 'Set' command
  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Color Presets':'$color_preset_name' dict" "$iterm2_plist"
#  /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Color Presets:Default':'$color_preset_name' dict" "$iterm2_plist"
#    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Color Presets':'Default' '$color_preset_name'" "$iterm2_plist"
#    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Color Presets':'Default' '$color_preset_name'" "$iterm2_plist"
#    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Color Presets':'Default' '$color_preset_name'" "$iterm2_plist"
/usr/libexec/PlistBuddy -c "Merge 'preset.plist' :'New Bookmarks':0:'Color Presets':'$color_preset_name'" "$iterm2_plist"

fi
}

rr(){

color_preset_path="$HOME/Desktop/custom.plist"  # Replace with the actual path to your color preset plist file

# Import the color preset using the defaults command
defaults import com.googlecode.iterm2 "$color_preset_path"

custom_plist_file="$HOME/Desktop/custom.plist"
iterm2_plist_file="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

/usr/libexec/PlistBuddy -c "Merge '$custom_plist_file' :'New Bookmarks':0:'Color Presets'" "$iterm2_plist_file"
}

ww(){
#todo shpould be moved when importing...
defaults write "$iterm2_plist" "Custom Color Presets:$color_preset_name"
defaults write "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "Custom Color Presets:Custom"

  # Set the desired color preset name
  color_preset_name="Custom"

  # Specify the path to the iTerm2 preferences plist file
  iterm2_plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

  # Check if the color preset exists in the plist
  preset_exists=$(defaults read "$iterm2_plist" "Custom Color Presets:$color_preset_name" 2>/dev/null)

  if [[ -n "$preset_exists" ]]; then
    # The color preset exists, set it as the default
    defaults write "$iterm2_plist" "Default Color Presets" -string "$color_preset_name"
    echo "Color preset '$color_preset_name' is set as the default."
  else
    # The color preset doesn't exist
    echo "Color preset '$color_preset_name' doesn't exist."
  fi

}
#ww

ii(){
color_preset_path="$HOME/Desktop/Custom.itermcolors"
color_preset_name="Custom"

# Import the color preset by copying it to the appropriate directory
cp "$color_preset_path" "$HOME/Library/Preferences/"

# Activate the imported color preset
/usr/libexec/PlistBuddy -c "Set :'Custom Color Presets':'$color_preset_name' \$(cat \"$HOME/Library/Preferences/color_preset.itermcolors\")" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
}

#iix






set_final(){

#todo this works
  # Path to the AppleScript script
  #cript_path="$ZSH_INSTALL/modules/dd.scpt"

  # Execute the AppleScript script
  #osascript "$script_path"

osascript "$ZSH_INSTALL/modules/test.applescript"

}

#set_final

defaults read com.googlecode.iterm2 "Default Bookmark Guid"


check_install_color_preset
install_color_preset
