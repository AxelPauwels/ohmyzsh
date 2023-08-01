# Variables
plugin_name='custom-zsh-base'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
cli_editor='nano'
path_to_zshrc="${HOME}/.zshrc"
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginZshBase="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginZshBase="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginZshBase="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias zshReload="source ${path_to_zshrc}"
alias zshEditZshrc="open -a ${editor} ${path_to_zshrc}"
alias zshInstall="${path_to_zsh_custom}/installation/install.sh"
alias zshInstallMore="${path_to_zsh_custom}/installation/install-more.sh"
alias zshInstallPowerlevel10k="${path_to_zsh_custom}/installation/configure-powerlevel.sh"
