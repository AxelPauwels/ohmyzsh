#!/usr/bin/env bash

install_fonts() {
  new_line
  msg_title "Fonts"
  msg_searching "Searching Fonts directory"

  if dir_exists "$HOME/Library/Fonts"; then
    msg_found "Found"
    msg_searching "Installing Fonts"

    msg_searching "Installing Fonts > MesloLGS"
    if ! file_exists "$HOME/Library/Fonts/MesloLGS\ NF\ Regular.ttf"; then
      cp -R "$ZSH_INSTALL/resources/fonts/MesloLGS/"* "$HOME/Library/Fonts"
    fi
    msg_found "MesloLGS installed"

    msg_searching "Installing Fonts > Powerline"
    if ! file_exists "$HOME/Library/Fonts/Source\ Code\ Pro\ for\ Powerline.otf"; then
      source "$ZSH_INSTALL//resources/fonts/Powerline/install.sh"
    fi
    msg_found "Powerline installed"

    msg_installed "Fonts installed"
  else
    msg_error "Error: $HOME/Library/Fonts does not exist"
  fi
}

check_install_fonts() {
  font_name="MesloLGS NF Regular"
  font_path="$HOME/Library/Fonts/$font_name.ttf"

  if file_exists "$font_path"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

install_fonts_manually() {
  install_fonts
}
