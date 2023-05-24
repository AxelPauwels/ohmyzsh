#!/usr/bin/env bash

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/"
ZSH_INSTALL="$HOME/.oh-my-zsh/custom/installation"

###########
# IMPORTS #
###########
chmod 755 "$ZSH_INSTALL"/config/variables.sh && source "$ZSH_INSTALL"/config/variables.sh
chmod 755 "$ZSH_INSTALL"/config/functions.sh && source "$ZSH_INSTALL"/config/functions.sh
chmod 755 "$ZSH_INSTALL"/config/messages.sh && source "$ZSH_INSTALL"/config/messages.sh
chmod 755 "$ZSH_INSTALL"/config/modules.sh && source "$ZSH_INSTALL"/config/modules.sh

#############
# VARIABLES #
#############
IsFullInstall=true       # true: will install everything automatically, false" user chooses what to install
InstallTextIsShown=false # to show only te text for the user once

########
# INIT #
########
if $MOD_XTOOLS; then chmod 755 "$ZSH_INSTALL"/modules/xtools.sh && source "$ZSH_INSTALL"/modules/xtools.sh; fi
if $MOD_HOMEBREW; then chmod 755 "$ZSH_INSTALL"/modules/homebrew.sh && source "$ZSH_INSTALL"/modules/homebrew.sh; fi
if $MOD_PYENV; then chmod 755 "$ZSH_INSTALL"/modules/pyenv.sh && source "$ZSH_INSTALL"/modules/pyenv.sh; fi
if $MOD_MAC; then chmod 755 "$ZSH_INSTALL"/modules/mac.sh && source "$ZSH_INSTALL"/modules/mac.sh; fi
if $MOD_GITHUB_CLI; then chmod 755 "$ZSH_INSTALL"/modules/github-cli.sh && source "$ZSH_INSTALL"/modules/github-cli.sh; fi
if $MOD_WARP; then chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh; fi
if $MOD_COMMANDS; then chmod 755 "$ZSH_INSTALL"/modules/commands.sh && source "$ZSH_INSTALL"/modules/commands.sh; fi

###########
# PROGRAM #
###########
showInstallationMessage() {
  new_line
  msg_title "What do you want to install/reinstall?"
  if $MOD_XTOOLS; then
    msg_inline "(1) Xtools "
    check_install_xcode_tools
  fi

  if $MOD_HOMEBREW; then
    msg_inline "(2) Homebrew "
    check_install_brew
  fi

  if $MOD_PYENV; then
    msg_inline "(3) Pyenv "
    check_install_pyenv
  fi

  if $MOD_MAC; then
    msg_inline "(4) Mac Cursor speed "
    check_install_keyrepeat
  fi
  # todo: add this
  #  if $MOD_MAC; then
  #    msg_inline "(5) Mac Show hidden files in Finder"
  #    check_install_keyrepeat
  #  fi

  if $MOD_GITHUB_CLI; then
    msg_inline "(6) GitHub CLI "
    check_install_github_cli
  fi

  msg_inline "(7) Command 'tree' "
  check_install_tree_command

  msg_dimmed "(q) Quit"
}

while true; do
  showInstallationMessage
  read -p "Option: " choice
  new_line
  case $choice in
  1)
    install_xcode_tools
    new_line
    ;;
  2)
    check_install_brew
    new_line
    ;;
  3)
    install_pyenv
    new_line
    ;;
  4)
    install_keyrepeat
    new_line
    ;;

  5)
    echo "todo"
    new_line
    ;;
  6)
    install_github_cli
    new_line
    ;;

  7)
    install_tree_command
    new_line
    ;;
  q | Q)
    exit
    ;;
  *)
    new_line
    msg_italic "Please choose a option (1-4/q)"
    ;;
  esac
done
