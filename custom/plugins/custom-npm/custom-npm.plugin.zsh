# Variables
plugin_name='custom-npm'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginNpm="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginNpm="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginNpm="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias npmCleanCache='npm cache clean --force'
alias npmCleanNodeModules='rm -rf node_modules && rm -rf node_modules'
alias npmCleanAll='npmCleanCache && npmCleanNodeModules'
