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

# Module sources provide the variables (paths, defaults keys) and check_* helpers
# the uninstallers rely on.
source "$ZSH_INSTALL"/modules/homebrew.sh
source "$ZSH_INSTALL"/modules/zsh.sh
source "$ZSH_INSTALL"/modules/fonts.sh
source "$ZSH_INSTALL"/modules/iterm.sh
source "$ZSH_INSTALL"/modules/terminal.sh
source "$ZSH_INSTALL"/modules/themes.sh
source "$ZSH_INSTALL"/modules/zshrc.sh
source "$ZSH_INSTALL"/modules/mac.sh
source "$ZSH_INSTALL"/modules/github-cli.sh
source "$ZSH_INSTALL"/modules/gitmoji.sh
source "$ZSH_INSTALL"/modules/commands.sh
source "$ZSH_INSTALL"/modules/uninstall.sh

###########
# PROGRAM #
###########
repo_version=$(get_repo_version)

menu_labels=()
menu_checks=()
menu_actions=()
menu_sections=()

menu_labels+=("Uninstall all");                menu_checks+=("");                                     menu_actions+=("uninstall_all")
# Blank separator line beneath "Uninstall all" (whitespace-only section).
menu_sections[1]=" "

menu_labels+=("Zsh");                          menu_checks+=("check_install_zsh");                    menu_actions+=("uninstall_zsh")
menu_labels+=("Zshrc file");                   menu_checks+=("status_zshrc");                         menu_actions+=("uninstall_zshrc")
menu_labels+=("Fonts");                        menu_checks+=("check_install_fonts");                  menu_actions+=("uninstall_fonts")
menu_labels+=("iTerm color & font settings");  menu_checks+=("check_install_color_preset_and_font");  menu_actions+=("uninstall_color_preset_and_font")
menu_labels+=("Terminal color & font settings"); menu_checks+=("check_install_terminal_font");          menu_actions+=("uninstall_terminal_font")
menu_labels+=("Theme Powerlevel10k");          menu_checks+=("check_install_theme_pk10");             menu_actions+=("uninstall_theme_pk10")
menu_labels+=("Prompt Powerlevel10k");         menu_checks+=("check_install_prompt_pk10");            menu_actions+=("uninstall_prompt_pk10")
menu_labels+=("Theme Agnoster");               menu_checks+=("check_install_theme_agnoster");         menu_actions+=("uninstall_theme_agnoster")
menu_labels+=("Mac Cursor speed");             menu_checks+=("check_install_keyrepeat");              menu_actions+=("uninstall_keyrepeat")
menu_labels+=("Mac Trackpad secondary click"); menu_checks+=("check_install_trackpad_secondary_click"); menu_actions+=("uninstall_trackpad_secondary_click")
menu_labels+=("Mac Finder hidden files");      menu_checks+=("check_install_finder_hidden");          menu_actions+=("uninstall_finder_hidden")
menu_labels+=("GitHub CLI");                   menu_checks+=("check_install_github_cli");             menu_actions+=("uninstall_github_cli")
menu_labels+=("Gitmoji CLI");                      menu_checks+=("check_install_gitmoji");                menu_actions+=("uninstall_gitmoji")
menu_labels+=("Gitmoji CLI commit-hook");          menu_checks+=("check_install_gitmoji_hook");           menu_actions+=("uninstall_gitmoji_hook")
menu_labels+=("Command 'tree'");               menu_checks+=("check_install_tree_command");           menu_actions+=("uninstall_tree_command")

menu_title="Uninstall Wizard v$repo_version"
menu_header="What do you want to uninstall?"
menu_selected=0
run_action_menu
clear
