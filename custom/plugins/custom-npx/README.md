# Work plugin
This custom plugin contains aliases related to [GitHub CLI](https://cli.github.com/)

To use it, add `custom-npx` to the plugins array in your zshrc file:

```zsh
plugins=(custom-npx)
```

## Variables
plugin_name='custom-npx'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias            | Command                                                                                      |
|:-----------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginNpx   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginNpx | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginNpx | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases

| Alias                  | Command                                  | Params                                            |
|:-----------------------|:-----------------------------------------|:--------------------------------------------------|
| nxLintProject          | npx nx lint                              | <nx-project> Example: nxLintProject kernel-shared |
| nxTestProject          | npx nx test                              | <nx-project> Example: nxLintProject kernel-shared |
| nxShowProjects         | npx nx show projects                     |                                                   |
| nxShowProjectsServable | npx nx show projects --with-target serve |                                                   |
| nxShowProjectInfo      | nx show project                          | <projectName>                                     |
