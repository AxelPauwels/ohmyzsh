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
    msg "(3) Change Powerlevel10k username/nickname"
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
    exec zsh -ic 'p10k configure; exec zsh'
    break
    ;;
  2)
    cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
    exec zsh
    break
    ;;
  3)
    p10k_config="$HOME/.p10k.zsh"
    if [ ! -f "$p10k_config" ]; then
      cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$p10k_config"
    fi

    read -r -p "Enter username/nickname: " p10k_nickname
    temp_p10k_config=$(mktemp)
    if awk -v nickname="$p10k_nickname" '
      /^[[:space:]]*#/ { print; next }
      /^[[:space:]]*POWERLEVEL9K_CONTEXT_TEMPLATE=/ {
        print "POWERLEVEL9K_CONTEXT_TEMPLATE='\''" nickname "'\''"
        replaced=1
        next
      }
      { print }
      END { exit(replaced ? 0 : 1) }
    ' "$p10k_config" >"$temp_p10k_config"; then
      mv "$temp_p10k_config" "$p10k_config"
      msg_success "Saved Powerlevel10k username/nickname."
    else
      rm -f "$temp_p10k_config"
      msg_error "Could not find an uncommented POWERLEVEL9K_CONTEXT_TEMPLATE= line in $p10k_config."
    fi

    new_line
    ConfigureMessageIsShown=false
    ;;
  q | Q)
    exec zsh
    break
    ;;
  *)
    new_line
    msg_italic "Please choose an option (1/2/3/q)"
    ;;
  esac
done
