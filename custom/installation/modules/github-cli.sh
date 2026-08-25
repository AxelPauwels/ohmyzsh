install_github_cli() {
  new_line
  msg_title "GitHub CLI"
  msg_searching "Checking GitHub CLI installation"

  if command_exists gh; then
    msg_found "Found"
  else
    msg_not_found "Not found"

    msg_searching "Installing GitHub CLI"
    install_brew
    brew install gh
    msg_found "Installed"
  fi

  msg_installed "GitHub CLI installed"
}

check_install_github_cli() {
  if command_exists gh; then
    msg_found_version "Installed" "$(extract_version "$(gh --version 2>/dev/null | head -1)")"
  else
    msg_not_found "Not installed"
  fi
}
