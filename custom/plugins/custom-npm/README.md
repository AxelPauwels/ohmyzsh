# Work plugin
This custom plugin contains aliases related to [npm](https://www.npmjs.com/)

To use it, add `custom-npm` to the plugins array in your zshrc file:

```zsh
plugins=(custom-npm)
```

## Variables
plugin_name='custom-npm'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias            | Command                                                                                      |
|:-----------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginNpm   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginNpm | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginNpm | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases
| Alias               | Command                                     |
|:--------------------|:--------------------------------------------|
| npmCleanCache       | npm cache clean --force                     |
| npmCleanNodeModules | rm -rf node_modules && rm -rf node_modules  |
| npmCleanAll         | npmCleanCache && npmCleanNodeModules        |

