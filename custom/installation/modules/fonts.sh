#!/usr/bin/env bash

install_fonts() {
  new_line
  msg_title "Fonts"
  msg_searching "Searching Fonts directory"

  if dir_exists "$HOME/Library/Fonts"; then
    msg_found "Found"
    msg_searching "Installing Fonts"

    msg_searching "Installing Fonts > MesloLGS"
    cp -R "$ZSH_INSTALL/resources/fonts/MesloLGS/"* "$HOME/Library/Fonts"
    msg_installed "Fonts installed"
  else
    msg_error "Error: $HOME/Library/Fonts does not exist"
  fi
}

# manual-installation-check
check_install_fonts() {
  font_name="MesloLGS NF Regular"
  font_path="$HOME/Library/Fonts/$font_name.ttf"

  if file_exists "$font_path"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
install_fonts_manually() {
  install_fonts
}
