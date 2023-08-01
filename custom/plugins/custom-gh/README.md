# Work plugin
This custom plugin contains aliases related to [GitHub CLI](https://cli.github.com/)

To use it, add `custom-gh` to the plugins array in your zshrc file:

```zsh
plugins=(custom-gh)
```

## Variables
plugin_name='custom-gh'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias           | Command                                                                                      |
|:----------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginGh   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginGh | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginGh | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |


## Aliases

| Alias            | Command                          |
|:-----------------|:---------------------------------|
| ghPrDevelopment  | gh pr create --base=development  |

