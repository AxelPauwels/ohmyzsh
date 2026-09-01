# needs brew before warp

# Adds the given line to a file only if it isn't already present.
# If before_pattern is provided and matches a line, the new line is inserted
# just before the first match (so `brew shellenv` lands before the pyenv/nvm
# section and their node stays ahead of Homebrew's node in PATH). Otherwise the
# line is appended at the end.
# params: file_path  line  [before_pattern]
add_line_if_missing() {
  local file_path="$1"
  local line="$2"
  local before_pattern="${3:-}"

  if [ ! -f "$file_path" ]; then
    touch "$file_path"
  fi

  if grep -qF "$line" "$file_path"; then
    msg_found "brew shellenv already present in $file_path"
    return 0
  fi

  if [ -n "$before_pattern" ] && grep -qE "$before_pattern" "$file_path"; then
    local tmp
    tmp="$(mktemp)"
    awk -v ins="$line" -v pat="$before_pattern" '
      !inserted && $0 ~ pat { print ins; print ""; inserted = 1 }
      { print }
    ' "$file_path" >"$tmp" && mv "$tmp" "$file_path"
    msg_found "Added brew shellenv before pyenv/nvm in $file_path"
  else
    {
      echo
      echo "$line"
    } >>"$file_path"
    msg_found "Added brew shellenv to $file_path"
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

  # Keep `brew shellenv` ahead of the pyenv/nvm loaders so their runtimes
  # (especially nvm's node) take precedence over Homebrew's in PATH.
  local before_pyenv_nvm='pyenv init|# for using nvm|NVM_DIR|nvm.sh|managed by install wizard'

  # ~/.zprofile is the correct file for zsh login shells on macOS (recommended by Homebrew).
  add_line_if_missing "$HOME/.zprofile" "$shellenv_line" "$before_pyenv_nvm"

  # If the current shell is zsh, also add it to ~/.zshrc so interactive shells pick it up.
  if [ -n "${ZSH_VERSION:-}" ] || string_contains_substring "${SHELL:-}" "zsh"; then
    add_line_if_missing "$HOME/.zshrc" "$shellenv_line" "$before_pyenv_nvm"
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
