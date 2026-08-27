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
  if $MOD_TERMINAL; then chmod 755 "$ZSH_INSTALL"/modules/terminal.sh && source "$ZSH_INSTALL"/modules/terminal.sh; fi
  if $MOD_THEMES; then chmod 755 "$ZSH_INSTALL"/modules/themes.sh && source "$ZSH_INSTALL"/modules/themes.sh; fi
  if $MOD_WARP; then
    chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh;
    chmod 755 "$ZSH_INSTALL"/resources/warp/themes/installable-custom-warp-theme.sh;
  fi
  if $MOD_ZSHRC; then chmod 755 "$ZSH_INSTALL"/modules/zshrc.sh && source "$ZSH_INSTALL"/modules/zshrc.sh; fi
  if $MOD_PYENV; then chmod 755 "$ZSH_INSTALL"/modules/pyenv.sh && source "$ZSH_INSTALL"/modules/pyenv.sh; fi
  if $MOD_NODE; then chmod 755 "$ZSH_INSTALL"/modules/node.sh && source "$ZSH_INSTALL"/modules/node.sh; fi
  if $MOD_NVM; then chmod 755 "$ZSH_INSTALL"/modules/nvm.sh && source "$ZSH_INSTALL"/modules/nvm.sh; fi
  if $MOD_MAC; then chmod 755 "$ZSH_INSTALL"/modules/mac.sh && source "$ZSH_INSTALL"/modules/mac.sh; fi
  if $MOD_JETBRAINS; then chmod 755 "$ZSH_INSTALL"/modules/jetbrains.sh && source "$ZSH_INSTALL"/modules/jetbrains.sh; fi
  if $MOD_GITHUB_CLI; then chmod 755 "$ZSH_INSTALL"/modules/github-cli.sh && source "$ZSH_INSTALL"/modules/github-cli.sh; fi
  if $MOD_GITMOJI; then chmod 755 "$ZSH_INSTALL"/modules/gitmoji.sh && source "$ZSH_INSTALL"/modules/gitmoji.sh; fi
  if $MOD_COMMANDS; then chmod 755 "$ZSH_INSTALL"/modules/commands.sh && source "$ZSH_INSTALL"/modules/commands.sh; fi
}

restartYourTerminalMessage() {
  msg_italic ""
  msg_italic "Restart your terminal to load all changes (certainly if your font has changed)"
}

_run_configure() {
  local rc=0
  bash "$ZSH_INSTALL"/configure-powerlevel.sh || rc=$?
  printf '\033[?25h' >&2
  clear
  # Exit code 90 means the user quit the configure wizard, so return to this menu.
  if [ "$rc" -eq 90 ]; then
    menu_action_submenu=1
    return 0
  fi
  exit
}

# Set the "Developer" key-repeat preset (2/8) without the interactive
# logout prompt that install_keyrepeat shows, so "Install all" can run
# unattended. Uses the same backup keys as the Mac module for uninstall.
_install_all_keyrepeat_dev() {
  new_line
  msg_title "Mac Cursor speed"
  backup_defaults -g KeyRepeat keyrepeat_key
  backup_defaults -g InitialKeyRepeat keyrepeat_delay
  defaults write -g KeyRepeat -int 2
  defaults write -g InitialKeyRepeat -int 10
  msg_installed "Cursor speed set to 'Developer' (takes effect after logout/login)"
}

# Apply Axel's Powerlevel10k preset (mirrors _configure_p10k_preset from
# configure-powerlevel.sh, which runs in a separate process).
_install_all_prompt_axel() {
  new_line
  msg_title "Configure your own prompt"
  p10k_state_set install axel
  p10k_state_set customized 0
  cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
  msg_installed "Applied 'Axel preset'"
}

# Install everything, starting with Homebrew, using the requested presets for
# the Mac tweaks and the prompt. Only modules that are enabled are run.
install_all() {
  new_line
  msg_title "Install all"

  # Homebrew first (also installs the Xcode Command Line Tools).
  if $MOD_HOMEBREW; then install_brew; fi

  # Then the rest.
  if $MOD_ZSH; then install_zsh_manually; fi
  if $MOD_ZSHRC; then override_zshrc_file_manually; fi
  if $MOD_FONTS; then install_fonts_manually; fi
  if $MOD_ITERM; then
    install_iterm_manually
    install_color_preset_and_font_manually
  fi
  if $MOD_TERMINAL; then install_terminal_font_manually; fi
  if $MOD_THEMES; then
    install_theme_pk10_manually
    install_theme_agnoster_manually
  fi
  if $MOD_WARP; then
    install_warp_manually
    install_warp_theme_manually
  fi
  if $MOD_PYENV; then install_pyenv; fi
  if $MOD_NODE; then install_node; fi
  if $MOD_NVM; then install_nvm; fi

  # Mac tweaks with the requested presets.
  if $MOD_MAC; then
    _install_all_keyrepeat_dev
    _trackpad_secondary_click_bottom_right
    _finder_show_hidden
  fi

  if $MOD_JETBRAINS; then install_jetbrains_plugins_all; fi
  if $MOD_GITHUB_CLI; then install_github_cli; fi
  if $MOD_GITMOJI; then install_gitmoji; fi
  if $MOD_COMMANDS; then install_tree_command; fi

  # Prompt: apply the Axel preset.
  _install_all_prompt_axel

  # Treat this as a normal (non-submenu) action so the menu engine waits for an
  # acknowledgement key before redrawing, even if a sub-installer flipped the flag.
  menu_action_submenu=0
  # Many items changed, so ask the menu to recompute every status line.
  menu_refresh_all=1
  new_line
  msg_installed "Install all finished"
}

###########
# PROGRAM #
###########
init
repo_version=$(get_repo_version)

menu_labels=()
menu_checks=()
menu_actions=()
menu_sections=()

# --- Install everything at once ---
menu_labels+=("Install all");                   menu_checks+=("");                                     menu_actions+=("install_all")
# Blank separator line beneath "Install all" (whitespace-only section).
menu_sections[1]=" "

# --- Installable components (formerly "partial installation") ---
if $MOD_ZSH; then
  menu_labels+=("Zsh");                         menu_checks+=("check_install_zsh");                    menu_actions+=("install_zsh_manually")
fi
if $MOD_ZSHRC; then
  menu_labels+=("Zshrc file");                  menu_checks+=("check_override_zshrc_file");            menu_actions+=("override_zshrc_file_manually")
fi
if $MOD_FONTS; then
  menu_labels+=("Fonts");                       menu_checks+=("check_install_fonts");                  menu_actions+=("install_fonts_manually")
fi
if $MOD_ITERM; then
  menu_labels+=("iTerm");                       menu_checks+=("check_install_iterm");                  menu_actions+=("install_iterm_manually")
  menu_labels+=("iTerm color & font settings"); menu_checks+=("check_install_color_preset_and_font");  menu_actions+=("install_color_preset_and_font_manually")
fi
if $MOD_TERMINAL; then
  menu_labels+=("Terminal color & font settings");      menu_checks+=("check_install_terminal_font");          menu_actions+=("install_terminal_font_manually")
fi
if $MOD_THEMES; then
  menu_labels+=("Theme Powerlevel10k");         menu_checks+=("check_install_theme_pk10");             menu_actions+=("install_theme_pk10_manually")
  menu_labels+=("Theme Agnoster");              menu_checks+=("check_install_theme_agnoster");         menu_actions+=("install_theme_agnoster_manually")
fi
if $MOD_WARP; then
  menu_labels+=("Warp");                        menu_checks+=("check_install_warp");                   menu_actions+=("install_warp_manually")
  menu_labels+=("Warp theme");                  menu_checks+=("check_install_warp_theme");             menu_actions+=("install_warp_theme_manually")
fi

# --- Extra stuff (formerly "install more stuff") ---
if $MOD_XTOOLS; then
  menu_labels+=("Xtools");                      menu_checks+=("check_install_xcode_tools");            menu_actions+=("install_xcode_tools")
fi
if $MOD_HOMEBREW; then
  menu_labels+=("Homebrew");                    menu_checks+=("check_install_brew");                   menu_actions+=("install_brew")
fi
if $MOD_PYENV; then
  menu_labels+=("Pyenv");                       menu_checks+=("check_install_pyenv");                  menu_actions+=("install_pyenv")
fi
if $MOD_NODE; then
  menu_labels+=("Node (node + npm)");           menu_checks+=("check_install_node");                   menu_actions+=("install_node")
fi
if $MOD_NVM; then
  menu_labels+=("Nvm");                         menu_checks+=("check_install_nvm");                    menu_actions+=("install_nvm")
fi
if $MOD_MAC; then
  menu_labels+=("Mac Cursor speed");            menu_checks+=("check_install_keyrepeat");              menu_actions+=("install_keyrepeat")
  menu_labels+=("Mac Trackpad secondary click"); menu_checks+=("check_install_trackpad_secondary_click"); menu_actions+=("install_trackpad_secondary_click")
  menu_labels+=("Mac Finder hidden files");     menu_checks+=("check_install_finder_hidden");          menu_actions+=("install_finder_hidden")
fi
if $MOD_JETBRAINS; then
  menu_labels+=("Jetbrains IntelliJ Plugins");  menu_checks+=("check_install_jetbrains");              menu_actions+=("install_jetbrains_plugins")
fi
if $MOD_GITHUB_CLI; then
  menu_labels+=("GitHub CLI");                  menu_checks+=("check_install_github_cli");             menu_actions+=("install_github_cli")
fi
if $MOD_GITMOJI; then
  menu_labels+=("Gitmoji");                     menu_checks+=("check_install_gitmoji");                menu_actions+=("install_gitmoji")
fi
if $MOD_COMMANDS; then
  menu_labels+=("Command 'tree'");              menu_checks+=("check_install_tree_command");           menu_actions+=("install_tree_command")
fi

# --- Prompt configuration ---
menu_labels+=("Configure your own prompt");     menu_checks+=("check_configure_prompt");               menu_actions+=("_run_configure")

menu_title="Install Wizard v$repo_version"
menu_header="What do you want to install/reinstall?"
menu_selected=0
run_action_menu

clear
new_line
msg_installed "Reloading your shell, please wait…"
exec zsh
