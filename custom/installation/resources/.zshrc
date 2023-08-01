# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# (commented for p10k, more info at the bottom)

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    custom-zsh-base
    custom-gh
    #custom-git
    custom-npm
    custom-npx
    custom-powerlevel10k
    custom-ssh
    custom-mac
    #custom-vagrant
    #custom-work
    custom-work-ravago
)
# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

##################################################################################
# Expansion
##################################################################################
# default editor
export EDITOR=/usr/bin/nano

# for setting custom prompt
#export DEFAULT_USER="$(whoami)" # because the check in agnoster theme... $USER != $DEFAULT_USER, this wil be omitted

# ensures that prompt is "always at the bottom" (should be before p10k instant prompt loading)
printf '\n%.0s' {1..100}

# set theme p10k (currently not supported by Warp, so use agnoster for warp)
if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
  ZSH_THEME="agnoster"
fi

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# if when installing through brew, use this setup:
# if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
#   if [[ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ]]; then
#     source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
#   fi
#   test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# fi


# powerlevel10k: To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# powerlevel10k: Disable the auto-p10k-configure script on start up when ~/.p10k.zsh does not exists
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# powerlevel10k: customization
# I added this in p10k.zsh itself at the bottom under section 'OVERRIDES'
# This is done because when in this file POWERLEVEL9K_* -constants are detected,
# the configure wizard (p10k configure) will never be executed
# (constant 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD' will be ignored at detection)
# See more https://github.com/romkatv/powerlevel10k#configuration-wizard-runs-automatically-every-time-zsh-is-started

# for path in zsh
export PATH="/usr/local/sbin:$PATH"

# for fixing 'missing python command', since now it's pyhton3) by default on mac
# alias python='python3' #seems not to work anymore
eval "$(pyenv init --path)"

# for using nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
# in combination with nvm: when changing directory... check if there is an nvmrc file.. if so... change version directly
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Load Angular CLI autocompletion.
#source <(ng completion script)

# should be as last
source $ZSH/oh-my-zsh.sh
