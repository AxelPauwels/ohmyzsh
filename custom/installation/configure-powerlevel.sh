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
showConfigureMenu() {
  local selected="$1"
  msg_title "How do you want to configure?"
  print_radio_option "$selected" 0 "Use the Powerlevel10k configuration wizard (recommended)"
  print_radio_option "$selected" 1 "Use Axel's Powerlevel10k configuration preset"
  print_radio_option "$selected" 2 "Change Powerlevel10k username/nickname"
  msg_dimmed "Use ↑/↓ and Enter. Press q to quit."
}

###########
# PROGRAM #
###########
new_line
repo_version=$(get_repo_version)
msg_title "Configure Powerlevel Wizard v$repo_version"
new_line

# user chooses
selected_option=0
while true; do
  clear
  msg_title "Configure Powerlevel Wizard v$repo_version"
  new_line
  showConfigureMenu "$selected_option"

  key=$(read_menu_key)
  case "$key" in
  $'\x1b[A')
    selected_option=$((selected_option - 1))
    if [ "$selected_option" -lt 0 ]; then
      selected_option=2
    fi
    ;;
  $'\x1b[B')
    selected_option=$((selected_option + 1))
    if [ "$selected_option" -gt 2 ]; then
      selected_option=0
    fi
    ;;
  "" | $'\n' | $'\r')
    case "$selected_option" in
    0)
      rm -rf "$HOME/.p10k.zsh" # Need to be deleted, otherwise the wizard script (p10k configure) will not be started
      exec zsh -ic 'p10k configure; exec zsh'
      break
      ;;
    1)
      cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
      exec zsh
      break
      ;;
    2)
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
      ;;
    esac
    ;;
  q | Q)
    exec zsh
    break
    ;;
  esac
done
