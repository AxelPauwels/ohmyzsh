#!/usr/bin/env bash

install_pyenv(){
  brew install pyenv
  #pyenv install --list
  #pyenv install --list | grep "3\.[0-9]" (to list more specific versions)
  #pyenv install 2.7.18 (or any other version)


latest_version=$(pyenv install --list | grep -v - | tail -1)

if [ -n "$latest_version" ]; then
  pyenv install "$latest_version" #(currently this is mambaforge)
else
  echo "Unable to retrieve the latest version."
fi

  pyenv install $latest_version
  #pyenv versions
  pyenv global $latest_version

  #TODO: add this to zshrc file:
  # set path for pyenv
  # eval "$(pyenv init --path)"
  # export PATH="$HOME/.pyenv/versions/mambaforge/bin:$PATH"

  #restart terminal
  #pyhton -V (show versions)

  # INFO
  # to switch versions:
  # pyenv versions (copy one)
  # pyenv global system
  # pyenv global 3.10.4

  # To Unistall:
  # pyenv uninstall 2.7.18

  # See https://stackoverflow.com/questions/71591971/how-to-fix-zsh-command-not-found-python-error-macos-monterey-12-3-python
  # See more: https://realpython.com/intro-to-pyenv/
  # See also local: https://realpython.com/intro-to-pyenv/#local
}

check_install_pyenv(){
  if command_exists pyenv; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
