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
InstallTextIsShown=false              # to show only te text for the user once
installationOverviewWithOptions=false # true: show numbers to choose as option

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
    message=$([ $installationOverviewWithOptions == true ] && echo "(1) Zsh " || echo "Zsh ")
    msg_inline "$message"

    check_install_zsh
  fi

  if $MOD_FONTS; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(2) Fonts " || echo "Fonts ")
    msg_inline "$message"

    check_install_fonts
  fi

  if $MOD_ITERM; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(3) iTerm " || echo "iTerm ")
    msg_inline "$message"

    check_install_iterm
  fi

  if $MOD_ITERM; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(4) iTerm color & font settings " || echo "iTerm color & font settings ")
    msg_inline "$message"

    check_install_color_preset_and_font
  fi

  if $MOD_THEMES; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(5) Theme Powerlevel10k " || echo "Theme Powerlevel10k ")
    msg_inline "$message"

    check_install_theme_pk10
  fi

  if $MOD_THEMES; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(6) Theme Agnoster " || echo "Theme Agnoster ")
    msg_inline "$message"

    check_install_theme_agnoster
  fi

  if $MOD_WARP; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(7) Warp " || echo "Warp ")
    msg_inline "$message"

    check_install_warp
  fi

  if $MOD_ITERM; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(8) Warp theme " || echo "Warp theme ")
    msg_inline "$message"

    check_install_warp_theme
  fi

  if $MOD_ZSHRC; then
    message=$([ $installationOverviewWithOptions == true ] && echo "(9) Zshrc " || echo "Zshrc ")
    msg_inline "$message"

    check_override_zshrc_file
  fi
}

restartYourTerminalMessage() {
  msg_italic "Restart your terminal to load all changes (certainly if your font has changed)"
  msg_italic "Install more stuff: ~/.oh-my-zsh/custom/installation/install-more.sh"
  msg_italic "Configure your own prompt: ~/.oh-my-zsh/custom/installation/configure.sh"
}

showInstallationMessage() {
  msg_title "Current Installation"
  installationOverview
  new_line

  if ! $InstallTextIsShown; then
    msg_title "How do you want to install?"
    msg "(1) Full installation"
    msg "(2) Partial installation"
    msg_dimmed "(q) Quit"
    InstallTextIsShown=true
  fi
}

showManualInstallationMessage() {
  msg_title "What do you want to install/reinstall?"
  installationOverview
  msg_dimmed "(q) Quit"
}

###########
# PROGRAM #
###########
init
new_line

# user chooses full or manual installation
while true; do
  showInstallationMessage
  read -p "Option: " choice
  new_line
  case $choice in
  1)
    break
    ;;
  2)
    IsFullInstall=false
    installationOverviewWithOptions=true
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
    showManualInstallationMessage
    read -p "Option: " choice
    new_line
    case $choice in
    1)
      install_zsh_manually
      new_line
      ;;
    2)
      install_fonts_manually
      new_line
      ;;
    3)
      install_iterm_manually
      new_line
      ;;
    4)
      install_color_preset_and_font_manually
      new_line
      ;;
    5)
      install_theme_pk10_manually
      new_line
      ;;
    6)
      install_theme_agnoster_manually
      new_line
      ;;
    7)
      install_warp_manually
      new_line
      ;;
    8)
      install_warp_theme_manually
      new_line
      ;;
    9)
      override_zshrc_file_manually
      new_line
      ;;
    q | Q)
      restartYourTerminalMessage
      exit
      ;;
    *)
      new_line
      msg_italic "Please choose a option (1-9/q)"
      ;;
    esac
  done
fi
