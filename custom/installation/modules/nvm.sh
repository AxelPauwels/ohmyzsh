#!/usr/bin/env bash

# Marker used to identify the nvm loader block that this wizard manages inside
# ~/.zprofile. Matching on this substring lets us re-position the block
# idempotently without depending on regex-special characters.
NVM_ZPROFILE_MARKER="managed by install wizard"

install_nvm() {
  if command_exists brew; then
    brew install nvm
    ensure_nvm_loads_after_brew
  else
    msg_warning "Homebrew is not installed. Please install Homebrew first."
  fi
}

# Guarantees that ~/.zprofile loads nvm AFTER `brew shellenv`, so nvm's node
# takes precedence over a Homebrew-installed node (`brew install node`) in PATH.
#
# Background: Homebrew's `node` formula lives in /opt/homebrew/bin, which
# `brew shellenv` prepends to PATH. If nvm is sourced *before* that line, the
# Homebrew node shadows every `nvm use`, so the prompt (and `node --version`)
# always shows the Homebrew/"system" version. Loading nvm last fixes this.
#
# This function is idempotent: it strips any existing nvm loader lines (managed
# or hand-written) and re-appends a single managed block at the end of the file,
# which is always after the `brew shellenv` line(s).
ensure_nvm_loads_after_brew() {
  new_line
  msg_title "nvm PATH precedence"
  local zprofile="$HOME/.zprofile"
  msg_searching "Ensuring nvm loads after brew shellenv in ~/.zprofile"

  [ -f "$zprofile" ] || touch "$zprofile"

  local stripped desired
  stripped="$(mktemp)"
  desired="$(mktemp)"

  # Remove our managed markers plus any nvm loader lines (managed or written by
  # the official nvm installer) so we can re-add one clean block at the end.
  grep -vE "${NVM_ZPROFILE_MARKER}|^[[:space:]]*export NVM_DIR=|NVM_DIR/nvm\.sh|NVM_DIR/bash_completion" \
    "$zprofile" \
    | awk '/^[[:space:]]*$/ {blank++; next} {for (; blank > 0; blank--) print ""; print}' \
    > "$stripped"

  {
    cat "$stripped"
    printf '\n# >>> nvm (%s) >>>\n' "$NVM_ZPROFILE_MARKER"
    printf '%s\n' 'export NVM_DIR="$HOME/.nvm"'
    printf '%s\n' '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
    printf '%s\n' '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'
    printf '# <<< nvm (%s) <<<\n' "$NVM_ZPROFILE_MARKER"
  } > "$desired"

  if cmp -s "$zprofile" "$desired"; then
    msg_found "Already correct (nvm loads after brew)"
    rm -f "$stripped" "$desired"
    return 0
  fi

  local backup
  backup="$(backup_file_datetime "$zprofile")"
  msg_found "Backed up to $backup"
  cp "$desired" "$zprofile"
  rm -f "$stripped" "$desired"
  msg_installed "nvm now loads after brew shellenv (node from nvm takes precedence)"
}

check_install_nvm() {
  if brew list nvm &>/dev/null; then
    msg_found_version "Installed" "$(brew list --versions nvm 2>/dev/null | head -1)"
  else
    msg_not_found "Not installed"
  fi
}
