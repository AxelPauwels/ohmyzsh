# Variables
plugin_name='custom-npx'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginNpx="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginNpx="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginNpx="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias nxLintProject='npx nx lint ' #param <nx-project> Example: nxLintProject kernel-shared
alias nxTestProject='npx nx test ' #param <nx-project> Example: nxTestProject kernel-shared
alias nxShowProjects='npx nx show projects'
alias nxShowProjectsServable='npx nx show projects --with-target serve'
alias nxShowProjectInfo='nx show project ' #param <projectName>
