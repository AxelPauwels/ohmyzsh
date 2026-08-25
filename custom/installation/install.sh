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
IsFullInstall=true                    # true: will install everything automatically, false" user chooses what to install
selected_install_mode=0
selected_manual_option=0

#############
# FUNCTIONS #
#############
init() {
  if $MOD_XTOOLS; then chmod 755 "$ZSH_INSTALL"/modules/xtools.sh && source "$ZSH_INSTALL"/modules/xtools.sh; fi
  if $MOD_HOMEBREW; then chmod 755 "$ZSH_INSTALL"/modules/homebrew.sh && source "$ZSH_INSTALL"/modules/homebrew.sh; fi
  if $MOD_TEST; then chmod 755 "$ZSH_INSTALL"/modules/test.sh && source "$ZSH_INSTALL"/modules/test.sh; fi
  if $MOD_ZSH; then chmod 755 "$ZSH_INSTALL"/modules/zsh.sh && source "$ZSH_INSTALL"/modules/zsh.sh; fi
  if $MOD_FONTS; then chmod 755 "$ZSH_INSTALL"/modules/fonts.sh && source "$ZSH_INSTALL"/modules/fonts.sh; fi
  if $MOD_ITERM; then
    chmod 755 "$ZSH_INSTALL"/modules/iterm.sh && source "$ZSH_INSTALL"/modules/iterm.sh
    chmod 755 "$ZSH_INSTALL"/modules/iterm-import-scheme.sh && source "$ZSH_INSTALL"/modules/iterm-import-scheme.sh
  fi
  if $MOD_THEMES; then chmod 755 "$ZSH_INSTALL"/modules/themes.sh && source "$ZSH_INSTALL"/modules/themes.sh; fi
  if $MOD_WARP; then
    chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh;
    chmod 755 "$ZSH_INSTALL"/resources/warp/themes/installable-custom-warp-theme.sh;
  fi
  if $MOD_ZSHRC; then chmod 755 "$ZSH_INSTALL"/modules/zshrc.sh && source "$ZSH_INSTALL"/modules/zshrc.sh; fi
}

installationOverview() {
  if $MOD_ZSH; then
    message="Zsh "
    msg_inline "$message"

    check_install_zsh
  fi

  if $MOD_FONTS; then
    message="Fonts "
    msg_inline "$message"

    check_install_fonts
  fi

  if $MOD_ITERM; then
    message="iTerm "
    msg_inline "$message"

    check_install_iterm
  fi

  if $MOD_ITERM; then
    message="iTerm color & font settings "
    msg_inline "$message"

    check_install_color_preset_and_font
  fi

  if $MOD_THEMES; then
    message="Theme Powerlevel10k "
    msg_inline "$message"

    check_install_theme_pk10
  fi

  if $MOD_THEMES; then
    message="Theme Agnoster "
    msg_inline "$message"

    check_install_theme_agnoster
  fi

  if $MOD_WARP; then
    message="Warp "
    msg_inline "$message"

    check_install_warp
  fi

  if $MOD_WARP; then
    message="Warp theme "
    msg_inline "$message"

    check_install_warp_theme
  fi

  if $MOD_ZSHRC; then
    message="Zshrc "
    msg_inline "$message"

    check_override_zshrc_file
  fi
}

restartYourTerminalMessage() {
  msg_italic ""
  msg_italic "Restart your terminal to load all changes (certainly if your font has changed)"
}

_open_install_more() { bash "$ZSH_INSTALL"/install-more.sh; menu_exit=1; }
_open_configure()    { bash "$ZSH_INSTALL"/configure-powerlevel.sh; menu_exit=1; }

whatNextMenu() {
  local menu_title="What's next?"
  local menu_header="Restart your terminal to load all changes (certainly if your font has changed)."
  local -a menu_labels=(
    "Install more stuff"
    "Configure your own prompt"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_open_install_more"
    "_open_configure"
  )
  local menu_selected=0
  run_action_menu
  clear
}

_choose_full_install()    { IsFullInstall=true;  menu_exit=1; }
_choose_partial_install() { IsFullInstall=false; menu_exit=1; }
_run_install_more() { bash "$ZSH_INSTALL"/install-more.sh; printf '\033[?25h' >&2; clear; exit; }
_run_configure()    { bash "$ZSH_INSTALL"/configure-powerlevel.sh; printf '\033[?25h' >&2; clear; exit; }

###########
# PROGRAM #
###########
init
repo_version=$(get_repo_version)

manual_labels=()
manual_checks=()
manual_actions=()

if $MOD_ZSH; then
  manual_labels+=("Zsh")
  manual_checks+=("check_install_zsh")
  manual_actions+=("install_zsh_manually")
fi
if $MOD_FONTS; then
  manual_labels+=("Fonts")
  manual_checks+=("check_install_fonts")
  manual_actions+=("install_fonts_manually")
fi
if $MOD_ITERM; then
  manual_labels+=("iTerm")
  manual_checks+=("check_install_iterm")
  manual_actions+=("install_iterm_manually")
  manual_labels+=("iTerm color & font settings")
  manual_checks+=("check_install_color_preset_and_font")
  manual_actions+=("install_color_preset_and_font_manually")
fi
if $MOD_THEMES; then
  manual_labels+=("Theme Powerlevel10k")
  manual_checks+=("check_install_theme_pk10")
  manual_actions+=("install_theme_pk10_manually")
  manual_labels+=("Theme Agnoster")
  manual_checks+=("check_install_theme_agnoster")
  manual_actions+=("install_theme_agnoster_manually")
fi
if $MOD_WARP; then
  manual_labels+=("Warp")
  manual_checks+=("check_install_warp")
  manual_actions+=("install_warp_manually")
fi
if $MOD_WARP; then
  manual_labels+=("Warp theme")
  manual_checks+=("check_install_warp_theme")
  manual_actions+=("install_warp_theme_manually")
fi
if $MOD_ZSHRC; then
  manual_labels+=("Zshrc")
  manual_checks+=("check_override_zshrc_file")
  manual_actions+=("override_zshrc_file_manually")
fi

# user chooses full or manual installation
menu_title="Install Wizard v$repo_version"
menu_header="$( { msg_title 'Current Installation'; installationOverview; } 2>&1 )
"$'\n'"How do you want to install?"
menu_labels=("Full installation" "Partial installation" "Install more stuff" "Configure your own prompt")
menu_checks=()
menu_actions=("_choose_full_install" "_choose_partial_install" "_run_install_more" "_run_configure")
menu_selected=$selected_install_mode
run_action_menu
if [ "${menu_quit:-0}" -eq 1 ]; then
  clear
  exit
fi
clear

# FULL installation
if $IsFullInstall; then
  if $MOD_TEST; then show_examples; fi
  if $MOD_ZSH; then install_zsh; fi
  if $MOD_FONTS; then install_fonts; fi
  if $MOD_ITERM; then
    install_iterm
    install_color_preset_and_font
  fi
  if $MOD_THEMES; then install_themes; fi
  if $MOD_WARP; then
    install_warp
    install_warp_theme
  fi
  if $MOD_ZSH; then override_zshrc_file; fi

  new_line
  restartYourTerminalMessage
  whatNextMenu
fi

# MANUAL installation
if ! $IsFullInstall; then
  menu_title="Install Wizard v$repo_version"
  menu_header="What do you want to install/reinstall?"
  menu_labels=("${manual_labels[@]}")
  menu_checks=("${manual_checks[@]}")
  menu_actions=("${manual_actions[@]}")
  menu_selected=$selected_manual_option
  run_action_menu
  whatNextMenu
  exit
fi
