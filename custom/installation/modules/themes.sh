#!/usr/bin/env bash

agnoster_file_name="agnoster.zsh-theme"

_install_powerlevel10k() {
  msg_title "Themes > powerlevel10k"
  msg_searching "Searching for themes directory"

  # install ~/.oh-my-zsh/custom/themes/powerlevel10k
  if dir_exists "$HOME/.oh-my-zsh/custom/themes"; then
    msg_found "Found"

    msg_searching "Searching for powerlevel10k theme"

    if ! dir_exists "./../themes/powerlevel10k"; then
      msg_not_found "Not found"

      msg_searching "Installing powerlevel10k theme"
      cp -R "$ZSH_INSTALL/resources/themes/powerlevel10k" "$ZSH/custom/themes"
      msg_found "Installed"
    else
      msg_found "powerlevel10k theme already installed"
    fi
    msg_installed "Powerlevel10k theme installed"
  fi

  new_line

  msg_searching "Searching for powerlevel10k config file"
  if file_exists "$HOME/.p10k.zsh"; then
    msg_found "Found"

    msg_searching "Copying existing powerlevel10k config file as backup (~/.p10k.zsh.old)"
    cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.old"
    msg_found "Copied"

    msg_searching "Overriding existing powerlevel10k config file"
    cp "$ZSH_INSTALL/resources/themes/.p10k.zsh" "$HOME/"
    msg_found "Overridden"
  else
    msg_not_found "No config file found"

    msg_searching "Creating a new powerlevel10k config file"
    cp "$ZSH_INSTALL/resources/themes/.p10k.zsh" "$HOME/"
    msg_found "Created"
  fi

  msg_installed "powerlevel10k config installed"
}

# because p10k-theme isn't currently supported for Warp,
# use Agnoster-theme instead for warp (which is determined in ~/.zshrc)
_install_agnoster() {
  msg_title "Themes > agnoster"
  msg_searching "Searching for themes directory"

  # install ~/.oh-my-zsh/custom/themes/agnoster
  if dir_exists "$HOME/.oh-my-zsh/custom/themes"; then
    msg_found "Found"

    msg_searching "Searching for agnoster theme"

    if ! file_exists "./../themes/$agnoster_file_name"; then
      msg_not_found "Not found"

      msg_searching "Installing agnoster theme"
      cp "$ZSH_INSTALL/resources/themes/$agnoster_file_name" "$ZSH/custom/themes"
      msg_found "Installed"
    else
      msg_found "agnoster theme already installed"
    fi
    msg_installed "Agnoster theme installed"
  fi
}

install_themes() {
  new_line
  msg_title "Themes"
  _install_powerlevel10k
  _install_agnoster
}

# manual-installation-check
check_install_theme_pk10() {
  p10k_theme_path="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"

  if dir_exists "$p10k_theme_path"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
install_theme_pk10_manually() {
  _install_powerlevel10k
}

# manual-installation-check
check_install_theme_agnoster() {
  agnoster_theme_path="$HOME/.oh-my-zsh/custom/themes/$agnoster_file_name"

  if file_exists "$agnoster_theme_path"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
install_theme_agnoster_manually() {
  _install_agnoster
}
