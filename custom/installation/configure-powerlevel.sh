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
# FUNCTIONS #
#############
_configure_p10k_wizard() {
  rm -rf "$HOME/.p10k.zsh" # Need to be deleted, otherwise the wizard script (p10k configure) will not be started
  exec zsh -ic 'p10k configure; exec zsh'
}

_configure_p10k_preset() {
  cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
  exec zsh
}

_configure_p10k_nickname() {
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
}

###########
# PROGRAM #
###########
repo_version=$(get_repo_version)

menu_title="Configure Powerlevel Wizard v$repo_version"
menu_header="How do you want to configure?"
menu_labels=(
  "Use the Powerlevel10k configuration wizard (recommended)"
  "Use Axel's Powerlevel10k configuration preset"
  "Change Powerlevel10k username/nickname"
)
menu_checks=()
menu_actions=(
  "_configure_p10k_wizard"
  "_configure_p10k_preset"
  "_configure_p10k_nickname"
)
menu_selected=0
run_action_menu
clear
exec zsh
