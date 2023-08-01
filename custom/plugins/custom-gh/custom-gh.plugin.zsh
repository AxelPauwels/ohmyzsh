# Variables
plugin_name='custom-gh'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginGh="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginGh="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginGh="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"


# Aliases
# alias ghPr='gh pr create --assignee @me --reviewer Roel-Frison_ravago,kevin-jannis_ravago,dennis-gadomski_ravago,teun-verhaert_ravago,bert-fonteyn_ravago,tim-frijters_ravago,niels-hamelryck_ravago'
# alias ghPr='gh pr create --base=' # will be defaulted to 'master' when omitted
alias ghPrDevelopment='gh pr create --base=development '
