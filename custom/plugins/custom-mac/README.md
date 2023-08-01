# Work plugin
This custom plugin contains aliases related to [npm](https://www.npmjs.com/)

To use it, add `custom-mac` to the plugins array in your zshrc file:

```zsh
plugins=(custom-mac)
```

## Variables
plugin_name='custom-mac'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Private Functions
Private Functions are not meant to be to call directly from CLI, but are more likely used in an alias

| Function                                     | Description                                       |                                                                                                                         
|:---------------------------------------------|:--------------------------------------------------|
| _toUpper <string>                            | Return the passed string as uppercase             |                                                                                                                               
| _logoutByUsername <string>                   | Executes a function that results in logging out   |                                                                                                                               
| _macCreateDesktop <boolean>                  | Toggles the visibility of icons on Desktop        |                                                                                                                               
| _macShowAllFiles <boolean>                   | Toggles the visibility of hidden files            |                                                                                                                               
| _macKeyrepeat <keyRepeat> <delayUntilRepeat> | Sets mac's keyRepeat and initialKeyRepeat values  |
| _macCheckPort <port-number>                  | Checks if port is in use                          |

Extra info:
keyRepeat: the value for "Key Repeat" in System Preferences > Keyboard/keyboard > Key Repeat
initialKeyRepeat: the value for "Delay Until Repeat" in System Preferences > Keyboard/keyboard > Delay Until Repeat

## Aliases (this plugin)

| Alias            | Command                                                                                      |
|:-----------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginMac   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginMac | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginMac | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases
| Alias                                              | Command                     |  
|:---------------------------------------------------|:----------------------------|
| macDesktopShow <boolean>                           | _macCreateDesktop true      |
| macDesktopHide <boolean>                           | _macCreateDesktop false     |
| macHiddenfilesShow <boolean>                       | _macShowAllFiles true       |
| macHiddenfilesHide <boolean>                       | _macShowAllFiles false      |
| macKeyrepeatDefault <keyRepeat> <delayUntilRepeat> | _macKeyrepeat 60 68         |
| macKeyrepeatMedium <keyRepeat> <delayUntilRepeat>  | _macKeyrepeat 30 34         |
| macKeyrepeatFast <keyRepeat> <delayUntilRepeat>    | _macKeyrepeat 1 5           |
| macKeyrepeatCustom <keyRepeat> <delayUntilRepeat>  | _macKeyrepeat 2 10          |
| macCheckPort <port-number>                         | _macCheckPort <port-number> |
| macKillProcess <process-id>                        | 'kill -9 '                  |
