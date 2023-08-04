# Variables
plugin_name='custom-git'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Aliases (this plugin)
alias zshCdPluginGit="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginGit="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginGit="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
#alias glg='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glgDetail='glg -p'
#alias glgs='git log --stat -p'
#alias glgg='git log --graph --all'
#alias glgShort='git shortlog -s | sort'
#alias gfetch='git fetch --all'
#alias gpull='git pull'
#alias gpush='git push'
#alias gpushOrigin='git push -u origin ' #param <branch-name>
#alias gpushTags='git push --tags'

# workflow
#alias gadd='git add' #param <file(s)>
#alias gco='git commit -m'
#alias gch='git checkout' #param <branch-name>
#alias gme='git merge' #param <branch-name>"
#alias gre='git rebase'
#alias gUntrack='git rm --cached' #param <file>

# workflow - master&develop
#alias gchM='git checkout master'
#alias gmeM='git merge master'
#alias greM='git rebase master'
#alias gchD='git checkout development'
#alias gmeD='git merge development'
#alias greD='git rebase development'

# branches
#alias gst='git status -u'
#alias gbr='git branch'
#alias gbrVerbose='git branch -vv'
#alias gbrTimeline='git branch -vv --sort=-committerdate'
#alias gbrTimelineReversed='git branch -vv --sort=committerdate'
#alias gbrDelete='git branch -D ' #param <branch_name>
alias gbrRename='git branch -m ' #param <new-branch-name>

# branches - remote
#alias gbrr='git branch -r'
#alias gbrrVerbose='git branch -vvr'
#alias gbrrTimeline='git branch -vvr --sort=-committerdate'
#alias gbrrTimelineReversed='git branch -vvr --sort=committerdate'
#alias gbrrDelete='git push origin -d ' #param <branch-name>
alias gbrrPrune='git remote prune origin'

# tags
alias gtagCreate='git tag -a ' #param <tagName> Example with message: gtagCreate "v1.10" -m "myMessage"
alias gtagShow='git tag -n'
alias gtagPush='git push --tags' #same as alias "gpushTags"
alias gtagDelete='git tag -d ' #param <tagname>
alias gtagDeleteRemote='git push --delete origin ' #param <tagname>

# refs
alias grefTags='git show-ref --tags'
alias grefHeads='git show-ref --heads'

# stash
#alias gstash='git stash'
#alias gstashL='git stash list'
#alias gstashP='git stash pop'
#alias gstashA='git stash apply'
#alias gstashC='git stash clear'
#alias gstashS='git stash show'

_gaddPattern() {
    git add ./"$1"
}

# add
alias gaddPattern='_gaddPattern' # param <pattern> Example Usage: gaddPattern "*.mapper.*"

#submodules
#alias gsubPull='git submodule update --remote'
#alias gsubStatus='git submodule status'


#overrides
alias gc='git commit --message'
alias gc!='git commit --amend --message'
