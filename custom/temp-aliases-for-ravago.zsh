#######
# zsh #
#######
alias zshReload='source ~/.zshrc'
alias zshEditAliases='nano ~/.oh-my-zsh/custom/temp-aliases-for-ravago.zsh'
alias zshShowAliases='cat ~/.oh-my-zsh/custom/temp-aliases-for-ravago.zsh'
alias zshInstall='~/.oh-my-zsh/custom/installation/install.sh'
alias zshInstallMore='~/.oh-my-zsh/custom/installation/install-more.sh'
alias zshInstallPowerlevel10k='~/.oh-my-zsh/custom/installation/configure-powerlevel.sh'

########
# p10k #
########
alias p10kUpdate='git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull'

######
# cd #
######
alias cdWms='cd ~/Ravago/Projects/wms-front'
alias cdWmsWepApp='cd ~/Ravago/Projects/wms-web-app'
alias cdIms='cd ~/Ravago/Projects/ims-front'
alias cdImsOffice='cd ~/Ravago/Projects/ims-office-front'
alias cdZsh='cd ~/.oh-my-zsh'

################
# project: wms #
################
alias wmsCheck='npm run wms:check'
alias wmsTest='npm run test'
alias wmsCheckAndTest='npm run wms:check-and-test'
alias wmsFormatStyles='npm run format:styles --fix'
alias wmsFormatPrettier='npm run format:prettier'

##############
# github cli #
##############
#alias ghPr='gh pr create --base=' # will be defaulted to 'master' when omitted
alias ghPrDevelopment='gh pr create --base=development '

#######
# npm #
#######
alias npmCleanCache='npm cache clean --force'
alias npmCleanNodeModules='rm -rf node_modules && rm -rf node_modules'
alias npmCleanAll='npmCleanCache && npmCleanNodeModules'

######
# nx #
######
alias nxLintProject='npx nx lint ' #param <nx-project> Example: nxLintProject kernel-shared
alias nxTestProject='npx nx test ' #param <nx-project> Example: nxTestProject kernel-shared
alias nxShowProjects='npx nx show projects'
alias nxShowProjectsServable='npx nx show projects --with-target serve'
alias nxShowProjectInfo='nx show project ' #param <projectName>

#######
# ssh #
#######
alias sshCheckIndetities='ssh-add -l'
alias sshCheckConnectionRavago='ssh -T git@github.com-axel-pauwels_ravago'
alias sshCheckConnectionRavagoSDC='ssh -T git@github.com-ravago-sdc'
alias sshCheckConnectionPersonal='ssh -T git@github.com-AxelPauwels'
_sshCheckConnectionsAll() {
    echo "Checking user 'axel-pauwels_ravago'..."
    sshCheckConnectionRavago
    echo "Checking user 'com-ravago-sdc'..."
    sshCheckConnectionRavagoSDC
    echo "Checking user 'AxelPauwels'..."
    sshCheckConnectionPersonal
}
alias sshCheckConnections='_sshCheckConnectionsAll'

_sshResetKeys() {
    echo "Starting SSH agent..."
    eval "$(ssh-agent -s)" (to start SSH agent)
    echo "Adding keys as identities..."
    ssh-add ~/.ssh/axel_ravago_id_rsa
    ssh-add ~/.ssh/id_ed25519
    echo "Checking identities (this should contain keys now)..."
    ssh-add -l
    echo ""
    echo "Checking connections..."
    _sshCheckConnectionsAll
}
alias sshResetKeys='_sshResetKeys'

#######
# git # (updated to not use functions (~/.oh-my-zsh/custom/installation/resources/aliases/3E-git.zsh)
#######
# log
alias glg='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glgDetail='glg -p'
alias glgs='git log --stat -p'
alias glgg='git log --graph --all'
alias glgShort='git shortlog -s | sort'
alias gfetch='git fetch --all'
alias gpull='git pull'
alias gpush='git push'
alias gpushOrigin='git push -u origin ' #param <branch-name>
alias gpushTags='"git push --tags'

# workflow
alias gadd='git add ' #param <file(s)>
alias gco='git commit -m '
alias gch='git checkout ' #param <branch-name>
alias gme='git merge ' #param <branch-name>"
alias gre='git rebase'
alias gUntrack='git rm --cached ' #param <file>

# workflow - master&develop
alias gchM='git checkout master'
alias gmeM='git merge master'
alias greM='git rebase master'
alias gchD='git checkout development'
alias gmeD='git merge development'
alias greD='git rebase development'

# branches
alias gst='git status -u'
alias gbr='git branch'
alias gbrVerbose='git branch -vv'
alias gbrTimeline='git branch -vv --sort=-committerdate'
alias gbrTimelineReversed='git branch -vv 
--sort=committerdate'
alias gbrDelete='git branch -D ' #param <branch_name>
alias gbrRename='git branch -m ' #param <new-branch-name>

# branches - remote
alias gbrr='git branch -r'
alias gbrrVerbose='git branch -vvr'
alias gbrrTimeline='git branch -vvr --sort=-committerdate'
alias gbrrTimelineReversed='git branch -vvr 
--sort=committerdate'
alias gbrrDelete='git push origin -d ' #param <branch-name>
alias gbrrPrune='git remote prune origin'

# branches - specific
alias gbrFeature='git branch -vv | grep feature'
alias gbrRelease='git branch -vv | grep release'

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
alias gstash='git stash'
alias gstashL='git stash list'
alias gstashP='git stash pop'
alias gstashA='git stash apply'
alias gstashC='git stash clear'
alias gstashS='git stash show'

# add
alias gaddPattern='f() { git add ./"$1"; }; f' // # param <pattern> Example Usage: gaddPattern "*.mapper.*"

#submodules
alias gsubPull='git submodule update --remote'
alias gsubStatus='git submodule status'
