# Custom git plugin
This custom Git plugin contains aliases and functions that I have been using for several years now.
It's a supplement or an override of the well-known [git-plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) that I also use.

To use it, add `custom-git` to the plugins array in your zshrc file:

```zsh
plugins=(
    git 
    custom-git #load this after plugin 'git' if you also use that one 
)
```

## Variables
plugin_name='custom-git'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

## Aliases (this plugin)

| Alias            | Command                                                                                      |
|:-----------------|:---------------------------------------------------------------------------------------------|
| zshCdPluginGit   | cd ${path_to_zsh_custom}/plugins/${plugin_name}                                              |
| zshShowPluginGit | cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh                   |
| zshEditPluginGit | open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh |

## Aliases

| Alias                       | Command                                                                                                                                 |
|:----------------------------|:----------------------------------------------------------------------------------------------------------------------------------------|
| glg                         | git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit |
| glgDetail                   | glg -p                                                                                                                                  |
| glgs                        | git log --stat -p                                                                                                                       |
| glgg                        | git log --graph --all                                                                                                                   |
| glgShort                    | git shortlog -s                                                                                                                         | sort |
| gfetch                      | git fetch --all                                                                                                                         |
| gpull                       | git pull                                                                                                                                |
| gpush                       | git push                                                                                                                                |
| gpushOrigin <branch-name>   | git push -u origin                                                                                                                      |
| gpushTags                   | git push --tags                                                                                                                         |
| gadd <file(s)>              | git add                                                                                                                                 |
| gaddPattern <pattern>       | _gaddPattern (calls function \| Example: gaddPattern "*.mapper.*")                                                                      |
| gco                         | git commit -m                                                                                                                           |
| gch <branch-name>           | git checkout                                                                                                                            |
| gme <branch-name>           | git merge                                                                                                                               |
| gre                         | git rebase                                                                                                                              |
| gUntrack <file>             | git rm --cached                                                                                                                         |
| gchM                        | git checkout master                                                                                                                     |
| gmeM                        | git merge master                                                                                                                        |
| greM                        | git rebase master                                                                                                                       |
| gchD                        | git checkout development                                                                                                                |
| gmeD                        | git merge development                                                                                                                   |
| greD                        | git rebase development                                                                                                                  |
| gst                         | git status -u                                                                                                                           |
| gbr                         | git branch                                                                                                                              |
| gbrVerbose                  | git branch -vv                                                                                                                          |
| gbrTimeline                 | git branch -vv --sort=-committerdate                                                                                                    |
| gbrTimelineReversed         | git branch -vv --sort=committerdate                                                                                                     |
| gbrDelete <branch-name>     | git branch -D                                                                                                                           |
| gbrRename <new-branch-name> | git branch -m                                                                                                                           |
| gbrr                        | git branch -r                                                                                                                           |
| gbrrVerbose                 | git branch -vvr                                                                                                                         |
| gbrrTimeline                | git branch -vvr --sort=-committerdate                                                                                                   |
| gbrrTimelineReversed        | git branch -vvr --sort=committerdate                                                                                                    |
| gbrrDelete <branch-name>    | git push origin -d                                                                                                                      |
| gbrrPrune                   | git remote prune origin                                                                                                                 |
| gtagCreate <tag-name>       | git tag -a (Example with message: gtagCreate "v1.10" -m "myMessage)                                                                     |
| gtagShow                    | git tag -n                                                                                                                              |
| gtagPush                    | git push --tags                                                                                                                         | "gpushTags |
| gtagDelete <tag-name>       | git tag -d                                                                                                                              |
| gtagDeleteRemote <tag-name> | git push --delete origin                                                                                                                |
| grefTags                    | git show-ref --tags                                                                                                                     |
| grefHeads                   | git show-ref --heads                                                                                                                    |
| gstash                      | git stash                                                                                                                               |
| gstashL                     | git stash list                                                                                                                          |
| gstashP                     | git stash pop                                                                                                                           |
| gstashA                     | git stash apply                                                                                                                         |
| gstashC                     | git stash clear                                                                                                                         |
| gstashS                     | git stash show                                                                                                                          |
| gsubPull                    | git submodule update --remote                                                                                                           |
| gsubStatus                  | git submodule status                                                                                                                    |
