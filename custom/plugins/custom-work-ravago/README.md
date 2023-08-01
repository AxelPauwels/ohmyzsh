# Ravago plugin
This custom plugin contains aliases and functions more specific to work related stuff at Ravago

To use it, add `custom-work-ravago` to the plugins array in your zshrc file:

```zsh
plugins=(custom-work-ravago)
```

## Variables
plugin_name='custom-work-ravago'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias                   | Command                                                                                      |
|:------------------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginWorkRavago   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginWorkRavago | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginWorkRavago | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases

| Alias       | Command                               |
|:------------|:--------------------------------------|
| cdWms       | cd ~/Ravago/Projects/wms-front        |
| cdWmsWepApp | cd ~/Ravago/Projects/wms-web-app      |
| cdIms       | cd ~/Ravago/Projects/ims-front        |
| cdImsOffice | cd ~/Ravago/Projects/ims-office-front |

## Aliases Project WMS2

| Alias              | Command                     |
|:-------------------|:----------------------------|
| wmsGraph           | npx nx graph                |
| wmsCheck           | npm run wms:check           |
| wmsTest            | npm run test                |
| wmsCheckAndTest    | npm run wms:check-and-test  |
| wmsFormatStyles    | npm run format:styles --fix |
| wmsFormatPrettier  | npm run format:prettier     |
