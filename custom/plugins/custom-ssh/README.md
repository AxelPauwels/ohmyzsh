# Work plugin
This custom plugin contains aliases related to ssh-keys

To use it, add `custom-ssh` to the plugins array in your zshrc file:

```zsh
plugins=(custom-ssh)
```

## Variables
plugin_name='custom-ssh'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Private Functions
Private Functions are not meant to be to call directly from CLI, but are more likely used in an alias

| Function                | Description                                                                                      |
|:------------------------|:-------------------------------------------------------------------------------------------------|
| _sshCheckConnectionsAll | Currently checks connection for users axel-pauwels_ravago,axel-pauwels-sdc,AxelPauwels(personal) |
| _sshResetKeys           | Starts ssh agent, adds defined keys to identities, check all conections                          |

## Aliases (this plugin)

| Alias            | Command                                                                                       |
|:-----------------|:----------------------------------------------------------------------------------------------|
| zshCdPluginSsh   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                               |
| zshShowPluginSsh | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                    |
| zshEditPluginSsh | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh  |

## Aliases

| Alias                       | Command                                   |
|:----------------------------|:------------------------------------------|
| sshCheckIndentities         | ssh-add -l                                |
| sshCheckConnectionRavago    | ssh -T git@github.com-axel-pauwels_ravago |
| sshCheckConnectionRavagoSDC | ssh -T git@github.com-ravago-sdc          |
| sshCheckConnectionPersonal  | ssh -T git@github.com-AxelPauwels         |

## Aliases based on functions

| Alias                | Command                                |
|:---------------------|:---------------------------------------|
| sshCheckConnections  | executes only _sshCheckConnectionsAll  |
| sshResetKeys         | executes _sshResetKeys                 |
