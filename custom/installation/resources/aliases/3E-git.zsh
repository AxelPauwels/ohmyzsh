# File: ~/.oh-my-zsh/custom/3E-git.zsh
# ------------------------------------


# log
alias glg='_aliasCommand "git log --graph --pretty=\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\""'
alias glgs='_aliasCommand "git log --stat -p"'
alias glgg='_aliasCommand "git log --graph --all"'
alias glgShort='_aliasCommandWithInfo "git shortlog -s | sort" "git shortlog -s | sort"'
# push/pull
alias gfetch='_aliasCommand "git fetch"'
alias gpull='_aliasCommand "git pull"'
alias gpush='_aliasCommand "git push"'
alias gpushOrigin='_aliasCommandWithInfo "git push -u origin <branch-name>" "git push -u origin"'
alias gpushTags='_aliasCommandWithInfo "Pushing tags to remote" "git push --tags"'
alias gPRSepagon='_aliasCommandWithInfo "git request-pull development git@github.com:AxelPauwels/sepagon.git <branch_name>" "git request-pull development git@github.com:AxelPauwels/sepagon.git"' 

# workflow
alias gadd='_aliasCommandWithInfo "git add <file(s)>" "git add"'
alias gco='git commit -m'
alias gch='_aliasCommandWithInfo "git checkout <branch-name>" "git checkout"'
alias gme='_aliasCommandWithInfo "git merge <branch-name>" "git merge"'
alias gre='_aliasCommand "git rebase"'
alias gUntrack='_aliasCommandWithInfo "git rm --cached <file>" "git rm --cached"'

# workflow - master&develop
alias gchM='_aliasCommand "git checkout master"'
alias gmeM='_aliasCommand "git merge master"'
alias greM='_aliasCommand "git rebase master"'
alias gchD='_aliasCommand "git checkout development"'
alias gmeD='_aliasCommand "git merge development"'
alias greD='_aliasCommand "git rebase development"'

# branches
alias gst='_aliasCommand "git status -u"'
alias gbr='_aliasCommandWithInfo "Showing local branches" "git branch"'
alias gbrVerbose='_aliasCommandWithInfo "Showing local branches" "git branch -vv"'
alias gbrTimeline='_aliasCommandWithInfo "Showing local branches, sorted by date" "git branch -vv --sort=-committerdate"'
alias gbrTimelineReversed='_aliasCommandWithInfo "Showing local branches, reversed-sorted by date" "git branch -vv --sort=committerdate"'
alias gbrDelete='_aliasCommandWithInfo "git branch -D <branch_name>" "git branch -D "'
alias gbrRename='_aliasCommandWithInfo "git branch -m <new-branch-name>" "git branch -m"'

# branches - remote
alias gbrr='_aliasCommandWithInfo "Showing remote branches" "git branch -r"'
alias gbrrVerbose='_aliasCommandWithInfo "Showing remote branches" "git branch -vvr"'
alias gbrrTimeline='_aliasCommandWithInfo "Showing remote branches, sorted by date" "git branch -vvr --sort=-committerdate"'
alias gbrrTimelineReversed='_aliasCommandWithInfo "Showing remote branches, reversed-sorted by date" "git branch -vvr --sort=committerdate"'
alias gbrrDelete='_aliasCommandWithInfo "git push origin -d <branch_name>" "git push origin -d "'
alias gbrrPrune='_aliasCommandWithInfo "Cleaning remote branches that does not exist anymore..." "git remote prune origin"'

# branches - specific
alias gbrFeature='_aliasCommandWithInfo "Showing local feature-branches" "git branch -vv | grep feature/"'
alias gbrRelease='_aliasCommandWithInfo "Showing local release-branches" "git branch -vv | grep release/"'

# tags
alias gtagCreate='_aliasCommandWithInfo "Usage: gtag \"v1.10\" -m \"myMessage\"" "git tag -a"'
alias gtagShow='_aliasCommandWithInfo "Showing all tags" "git tag -n"'
alias gtagPush='_aliasCommandWithInfo "Pushing tags to remote" "git push --tags"' #(same as alias "gpushTags")
alias gtagDelete='_aliasCommandWithInfo "git tag -d <tag> (use gtagDeleteRemote to push this tag-deletion to remote)" "git tag -d "' 
alias gtagDeleteRemote='_aliasCommandWithInfo "git push --delete origin <tag>" "git push --delete origin"'

# refs
alias grefTags='_aliasCommandWithInfo "Showing refs/tags" "git show-ref --tags"'
alias grefHeads='_aliasCommandWithInfo "Showing refs/heads" "git show-ref --heads"'

# stash
alias gstash='_aliasCommand "git stash"'
alias gstashL='_aliasCommand "git stash list"'
alias gstashP='_aliasCommand "git stash pop"'
alias gstashA='_aliasCommand "git stash apply"'
alias gstashC='_aliasCommand "git stash clear"'
alias gstashS='_aliasCommand "git stash show"'

#submodules
alias gsubPull='_aliasCommand "git submodule update --remote"'
alias gsubStatus='_aliasCommand "git submodule status"'

# End-of-file --------------------------------
#echo "${COLOR_GREEN}${EMOJI_CHECK}${COLOR_GRAY25} Git${COLOR_RESET}"
