# Work plugin
This custom plugin contains aliases related to [GitHub CLI](https://cli.github.com/)

To use it, add `custom-vagrant` to the plugins array in your zshrc file:

```zsh
plugins=(custom-vagrant)
```

## Variables
plugin_name='custom-vagrant'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias                | Command                                                                                      |
|:---------------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginVagrant   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginVagrant | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginVagrant | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases

| Alias      | Command            | 
|:-----------|:-------------------|
| vup        | vagrant up         |
| vssh       | vagrant ssh        |
| vst        | vagrant status     |
| vh         | vagrant halt       |
| vsus       | vagrant suspend    |
| vrel       | vagrant reload     |
| vsshConfig | vagrant ssh-config |
