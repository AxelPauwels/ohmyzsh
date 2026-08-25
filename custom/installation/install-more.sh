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

# Always restore the cursor on exit/interrupt (the menu engine hides it).
install_cursor_guard

#############
# VARIABLES #
#############
selected_option=0

########
# INIT #
########
if $MOD_XTOOLS; then chmod 755 "$ZSH_INSTALL"/modules/xtools.sh && source "$ZSH_INSTALL"/modules/xtools.sh; fi
if $MOD_HOMEBREW; then chmod 755 "$ZSH_INSTALL"/modules/homebrew.sh && source "$ZSH_INSTALL"/modules/homebrew.sh; fi
if $MOD_PYENV; then chmod 755 "$ZSH_INSTALL"/modules/pyenv.sh && source "$ZSH_INSTALL"/modules/pyenv.sh; fi
if $MOD_NODE; then chmod 755 "$ZSH_INSTALL"/modules/node.sh && source "$ZSH_INSTALL"/modules/node.sh; fi
if $MOD_NVM; then chmod 755 "$ZSH_INSTALL"/modules/nvm.sh && source "$ZSH_INSTALL"/modules/nvm.sh; fi
if $MOD_MAC; then chmod 755 "$ZSH_INSTALL"/modules/mac.sh && source "$ZSH_INSTALL"/modules/mac.sh; fi
if $MOD_JETBRAINS; then chmod 755 "$ZSH_INSTALL"/modules/jetbrains.sh && source "$ZSH_INSTALL"/modules/jetbrains.sh; fi
if $MOD_GITHUB_CLI; then chmod 755 "$ZSH_INSTALL"/modules/github-cli.sh && source "$ZSH_INSTALL"/modules/github-cli.sh; fi
if $MOD_WARP; then chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh; fi
if $MOD_COMMANDS; then chmod 755 "$ZSH_INSTALL"/modules/commands.sh && source "$ZSH_INSTALL"/modules/commands.sh; fi

###########
# PROGRAM #
###########
repo_version=$(get_repo_version)

showInstallationMessage() {
  msg_title "What do you want to install/reinstall?"
  for i in "${!menu_labels[@]}"; do
    if [ "$selected_option" -eq "$i" ]; then
      marker=" ◉ "
    else
      marker="[◯]"
    fi
    msg_inline "  $marker ${menu_labels[$i]} "
    "${menu_checks[$i]}"
  done
  msg_dimmed "Use ↑/↓ and Enter. Press q to quit."
}

menu_labels=()
menu_checks=()
menu_actions=()

if $MOD_XTOOLS; then
  menu_labels+=("Xtools")
  menu_checks+=("check_install_xcode_tools")
  menu_actions+=("install_xcode_tools")
fi

if $MOD_HOMEBREW; then
  menu_labels+=("Homebrew")
  menu_checks+=("check_install_brew")
  menu_actions+=("install_brew")
fi

if $MOD_PYENV; then
  menu_labels+=("Pyenv")
  menu_checks+=("check_install_pyenv")
  menu_actions+=("install_pyenv")
fi

if $MOD_NODE; then
  menu_labels+=("Node (node + npm)")
  menu_checks+=("check_install_node")
  menu_actions+=("install_node")
fi

if $MOD_NVM; then
  menu_labels+=("Nvm")
  menu_checks+=("check_install_nvm")
  menu_actions+=("install_nvm")
fi

if $MOD_MAC; then
  menu_labels+=("Mac Cursor speed")
  menu_checks+=("check_install_keyrepeat")
  menu_actions+=("install_keyrepeat")

  menu_labels+=("Mac Finder hidden files")
  menu_checks+=("check_install_finder_hidden")
  menu_actions+=("install_finder_hidden")
fi

if $MOD_JETBRAINS; then
  menu_labels+=("Jetbrains IntelliJ Plugins")
  menu_checks+=("check_install_jetbrains")
  menu_actions+=("install_jetbrains_plugins")
fi

if $MOD_GITHUB_CLI; then
  menu_labels+=("GitHub CLI")
  menu_checks+=("check_install_github_cli")
  menu_actions+=("install_github_cli")
fi

menu_labels+=("Command 'tree'")
menu_checks+=("check_install_tree_command")
menu_actions+=("install_tree_command")

menu_title="Install More Wizard v$repo_version"
menu_header="What do you want to install/reinstall?"
menu_selected=$selected_option
run_action_menu
clear
