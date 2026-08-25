# needs brew before warp

# Appends the given line to a file only if it isn't already present.
# params: file_path  line
add_line_if_missing() {
  local file_path="$1"
  local line="$2"

  if [ ! -f "$file_path" ]; then
    touch "$file_path"
  fi

  if ! grep -qF "$line" "$file_path"; then
    {
      echo
      echo "$line"
    } >>"$file_path"
    msg_found "Added brew shellenv to $file_path"
  else
    msg_found "brew shellenv already present in $file_path"
  fi
}

setup_brew_shellenv() {
  local brew_bin=""
  if [ -x /opt/homebrew/bin/brew ]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin="/usr/local/bin/brew"
  elif command_exists brew; then
    brew_bin="$(command -v brew)"
  else
    msg_error "Could not locate the brew binary to configure shellenv."
    return 1
  fi

  local shellenv_line="eval \"\$($brew_bin shellenv)\""

  # ~/.zprofile is the correct file for zsh login shells on macOS (recommended by Homebrew).
  add_line_if_missing "$HOME/.zprofile" "$shellenv_line"

  # If the current shell is zsh, also add it to ~/.zshrc so interactive shells pick it up.
  if [ -n "${ZSH_VERSION:-}" ] || string_contains_substring "${SHELL:-}" "zsh"; then
    add_line_if_missing "$HOME/.zshrc" "$shellenv_line"
  fi

  # Make brew available in the current session.
  eval "$("$brew_bin" shellenv)"
}

install_brew() {
  msg_searching "Checking brew"
  install_xcode_tools

  if command_exists brew; then
    msg_found "Found"
  else
    msg_not_found "Not installed"

    msg_searching "Installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    msg_found "installed"

    setup_brew_shellenv
  fi

  msg_installed "Brew installed"
}

check_install_brew() {
  if command_exists brew; then
    msg_found_version "Installed" "$(extract_version "$(brew --version 2>/dev/null | head -1)")"
  else
    msg_not_found "Not installed"
  fi
}
