# Custom zsh-base plugin
This custom plugin contains aliases regarding the ZSH/OMZH system

To use it, add `custom-zsh-base` to the plugins array in your zshrc file:

```zsh
plugins=(custom-zsh-base)
```

## Variables
This plugin uses local variables depending on previously exported variables.
Normally you should not change these local variables.
But If you have other settings or special config... check and update these variables before usage:

plugin_name='custom-zsh-base'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
cli_editor='nano'
path_to_zshrc="${HOME}/.zshrc"
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias                | Command                                                                                      |
|:---------------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginZshBase   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginZshBase | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginZshBase | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases

| Alias                   | Command                                                    |
|:------------------------|:-----------------------------------------------------------|
| zshReload               | source ${path_to_zshrc}                                    |
| zshEdit                 | open -a \"${editor}\" ${path_to_zsh}                       |
| zshInstall              | ${path_to_zsh_custom}/installation/install.sh              |
| zshInstallMore          | ${path_to_zsh_custom}/installation/install-more.sh         |
| zshInstallPowerlevel10k | ${path_to_zsh_custom}/installation/configure-powerlevel.sh |
