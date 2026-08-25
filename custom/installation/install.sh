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

  if $MOD_ITERM; then
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
  msg_italic "Restart your terminal to load all changes (certainly if your font has changed)"
  msg_italic "Install more stuff: ~/.oh-my-zsh/custom/installation/install-more.sh"
  msg_italic "Configure your own prompt: ~/.oh-my-zsh/custom/installation/configure-powerlevel.sh"
}

showInstallationMessage() {
  msg_title "Current Installation"
  installationOverview
  new_line
  msg_title "How do you want to install?"
  print_radio_option "$selected_install_mode" 0 "Full installation"
  print_radio_option "$selected_install_mode" 1 "Partial installation"
  msg_dimmed "Use ↑/↓ and Enter. Press q to quit."
}

showManualInstallationMessage() {
  msg_title "What do you want to install/reinstall?"
  for i in "${!manual_labels[@]}"; do
    if [ "$selected_manual_option" -eq "$i" ]; then
      marker="(◉)"
    else
      marker="(◯)"
    fi
    msg_inline "  $marker ${manual_labels[$i]} "
    "${manual_checks[$i]}"
  done
  msg_dimmed "Use ↑/↓ and Enter. Press q to quit."
}

###########
# PROGRAM #
###########
init
new_line
repo_version=$(get_repo_version)
msg_title "Install Wizard v$repo_version"
new_line

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
if $MOD_ITERM; then
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
while true; do
  clear
  msg_title "Install Wizard v$repo_version"
  new_line
  showInstallationMessage
  key=$(read_menu_key)
  case "$key" in
  $'\x1b[A')
    selected_install_mode=$((selected_install_mode - 1))
    if [ "$selected_install_mode" -lt 0 ]; then
      selected_install_mode=1
    fi
    ;;
  $'\x1b[B')
    selected_install_mode=$((selected_install_mode + 1))
    if [ "$selected_install_mode" -gt 1 ]; then
      selected_install_mode=0
    fi
    ;;
  "" | $'\n' | $'\r')
    if [ "$selected_install_mode" -eq 1 ]; then
      IsFullInstall=false
    fi
    break
    ;;
  q | Q)
    exit
    ;;
  esac
done

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
fi

# MANUAL installation
if ! $IsFullInstall; then
  while true; do
    clear
    msg_title "Install Wizard v$repo_version"
    new_line
    showManualInstallationMessage
    key=$(read_menu_key)
    case "$key" in
    $'\x1b[A')
      selected_manual_option=$((selected_manual_option - 1))
      if [ "$selected_manual_option" -lt 0 ]; then
        selected_manual_option=$((${#manual_labels[@]} - 1))
      fi
      ;;
    $'\x1b[B')
      selected_manual_option=$((selected_manual_option + 1))
      if [ "$selected_manual_option" -ge "${#manual_labels[@]}" ]; then
        selected_manual_option=0
      fi
      ;;
    "" | $'\n' | $'\r')
      "${manual_actions[$selected_manual_option]}"
      new_line
      ;;
    q | Q)
      restartYourTerminalMessage
      exit
      ;;
    esac
  done
fi
