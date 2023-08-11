# Variables
plugin_name='custom-work-ravago'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginWorkRavago="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginWorkRavago="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginWorkRavago="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias cdWms='cd ~/Ravago/Projects/wms-front'
alias cdWmsWepApp='cd ~/Ravago/Projects/wms-web-app'
alias cdIms='cd ~/Ravago/Projects/ims-front'
alias cdImsOffice='cd ~/Ravago/Projects/ims-office-front'
alias cdZsh='cd ~/.oh-my-zsh'
#alias huskySetExecutable='chmod ug+x .husky/* && chmod ug+x .git/hooks/*'
#alias npmInstall='npm ci -s' ### -s is silent to supress the warnings

# Aliases Project WMS2
alias wmsGraph='npx nx graph'
alias wmsCheck='npm run wms:check'
alias wmsTest='npm run test'
alias wmsCheckAndTest='npm run wms:check-and-test'
alias wmsFormatStyles='npm run format:styles --fix'
alias wmsFormatPrettier='npm run format:prettier'
#alias wmsTest='(){ npx nx test $1;}'           ### add a NX projectname after this command like 'npxTest foundation'
#alias wmsLint='(){ npx nx lint $1 --quiet;}'   ### add a NX projectname after this command like 'npxLint kernel-shared'
