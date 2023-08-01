# Variables
plugin_name='custom-powerlevel10k'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
path_to_p10k_config_file="${HOME}/.p10k.zsh"

# Aliases (this plugin)
alias zshCdPluginPowerlevel10k="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginSPowerlevel10k="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginPowerlevel10k="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias p10kUpdate="git -C ${path_to_zsh_custom}/themes/powerlevel10k pull"
alias p10kEditConfig="open -a ${editor} ${path_to_p10k_config_file}"
