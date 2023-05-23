# needs xcode-select before brew
install_xcode_tools() {
  msg_searching "Checking xcode-tools (required for brew)"

  if command_exists xcode-select; then
    msg_found "Found"
  else
    msg_not_found "Not installed"

    msg_searching "Installing xcode tools"
    xcode-select --install
    msg_found "Installed"
  fi

  msg_installed "Xcode tools installed"
}

check_install_xcode_tools() {
  if command_exists xcode-select; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
