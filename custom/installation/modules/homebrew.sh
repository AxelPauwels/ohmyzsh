# needs brew before warp
install_brew() {
  msg_searching "Checking brew (required for warp)"
  install_xcode_tools

  if command_exists brew; then
    msg_found "Found"
  else
    msg_not_found "Not installed"

    msg_searching "Installing brew"

    chmod 755 "$ZSH_INSTALL/modules/homebrew-install.sh" && source "$ZSH_INSTALL/modules/homebrew-install.sh"
    msg_found "installed"

    # Note: could be different on other OS, If so fix this by removing these 2 lines
    (
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>"$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # msg_warning "If you have a warning that '/opt/homebrew/bin is not in your PATH' ..."
    # msg_warning "Just execute these suggested commands in your terminal and run this install.sh again."
  fi

  msg_installed "Brew installed"
}

check_install_brew() {
  if command_exists brew; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
