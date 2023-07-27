#!/usr/bin/env bash

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/"
ZSH_INSTALL="$HOME/.oh-my-zsh/custom/installation"

###########
# IMPORTS #
###########
chmod 755 "$ZSH_INSTALL"/config/variables.sh && source "$ZSH_INSTALL"/config/variables.sh
chmod 755 "$ZSH_INSTALL"/config/functions.sh && source "$ZSH_INSTALL"/config/functions.sh
chmod 755 "$ZSH_INSTALL"/config/messages.sh && source "$ZSH_INSTALL"/config/messages.sh

#############
# VARIABLES #
#############
ConfigureMessageIsShown=false # to show only te text for the user once

#############
# FUNCTIONS #
#############
showConfigureMessage() {
  if ! $ConfigureMessageIsShown; then
    msg_title "How do you want to configure?"
    msg "(1) Use the Powerlevel10k configuration wizard (recommended)"
    msg "(2) Reset to saved configuration in git"
    msg_dimmed "(q) Quit"
    ConfigureMessageIsShown=true
  fi
}

###########
# PROGRAM #
###########
new_line

# user chooses
while true; do
  showConfigureMessage
  read -p "Option: " choice
  case $choice in
  1)
    rm -rf "$HOME/.p10k.zsh" # Need to be deleted, otherwise the wizard script (p10k configure) will not be started
    exec zsh
    break
    ;;
  2)
    cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
    exec zsh
    break
    ;;
  q | Q)
    exit
    ;;
  *)
    new_line
    msg_italic "Please choose a option (1/2/q)"
    ;;
  esac
done
