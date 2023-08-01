# Work plugin
This custom plugin contains aliases related to [GitHub CLI](https://cli.github.com/)

To use it, add `custom-powerlevel10k` to the plugins array in your zshrc file:

```zsh
plugins=(custom-powerlevel10k)
```

## Variables
plugin_name='custom-powerlevel10k'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias                      | Command                                                                                      |
|:---------------------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginPowerlevel10k   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginPowerlevel10k | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginPowerlevel10k | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Variables
This plugin uses local variables depending on previously exported variables.
Normally you should not change these local variables.
But If you have other settings or special config... check and update these variables before usage:

editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
path_to_p10k_config_file="${HOME}/.p10k.zsh"

## Aliases

| Alias          | Command                                                |
|:---------------|:-------------------------------------------------------|
| p10kUpdate     | git -C ${path_to_zsh_custom}/themes/powerlevel10k pull |
| p10kEditConfig | open -a ${editor} ${path_to_p10k_config_file}          |
