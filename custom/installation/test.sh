#!/usr/bin/env bash


#todo add reamMe with documentation
##TODO: install with brew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
##TODO: copy first latest brew ? install with brew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

##TODO: Add jetbrains config?
##TODO: Add tree command?
##TODO: suggest keyrepeat
##TODO: Add homebrew command?


ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/"
ZSH_INSTALL="$HOME/.oh-my-zsh/custom/installation"

###########
# IMPORTS #
###########
chmod 755 "$ZSH_INSTALL"/config/variables.sh && source "$ZSH_INSTALL"/config/variables.sh
chmod 755 "$ZSH_INSTALL"/config/functions.sh && source "$ZSH_INSTALL"/config/functions.sh
chmod 755 "$ZSH_INSTALL"/config/messages.sh && source "$ZSH_INSTALL"/config/messages.sh
chmod 755 "$ZSH_INSTALL"/config/modules.sh && source "$ZSH_INSTALL"/config/modules.sh

init() {
  if $MOD_TEST; then chmod 755 "$ZSH_INSTALL"/modules/test.sh && source "$ZSH_INSTALL"/modules/test.sh; fi
  if $MOD_ZSH; then chmod 755 "$ZSH_INSTALL"/modules/zsh.sh && source "$ZSH_INSTALL"/modules/zsh.sh; fi
  if $MOD_FONTS; then chmod 755 "$ZSH_INSTALL"/modules/fonts.sh && source "$ZSH_INSTALL"/modules/fonts.sh; fi
  if $MOD_ITERM; then chmod 755 "$ZSH_INSTALL"/modules/iterm.sh && source "$ZSH_INSTALL"/modules/iterm.sh; fi
  if $MOD_THEMES; then chmod 755 "$ZSH_INSTALL"/modules/themes.sh && source "$ZSH_INSTALL"/modules/themes.sh; fi
  if $MOD_WARP; then chmod 755 "$ZSH_INSTALL"/modules/warp.sh && source "$ZSH_INSTALL"/modules/warp.sh; fi
  if $MOD_ZSHRC; then chmod 755 "$ZSH_INSTALL"/modules/zshrc.sh && source "$ZSH_INSTALL"/modules/zshrc.sh; fi
  if $MOD_PYENV; then chmod 755 "$ZSH_INSTALL"/modules/pyenv.sh && source "$ZSH_INSTALL"/modules/pyenv.sh; fi
}
init

if $MOD_TEST;then show_examples; fi
