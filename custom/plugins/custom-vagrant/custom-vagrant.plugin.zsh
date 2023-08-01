# Variables
plugin_name='custom-vagrant'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginVagrant="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginVagrant="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginVagrant="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vst='vagrant status'
alias vh='vagrant halt'
alias vsus='vagrant suspend'
alias vrel='vagrant reload'
alias vsshConfig='vagrant ssh-config'
