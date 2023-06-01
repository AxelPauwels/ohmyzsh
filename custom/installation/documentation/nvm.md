# nvm

## Remove existing Node Versions
brew uninstall --ignore-dependencies node
brew uninstall --force node

## Install NVM
brew update
brew install nvm
mkdir ~/.nvm

nano ~/.zshrc (or ~/bash_profile)
export NVM_DIR=~/.nvm

source $(brew --prefix nvm)/nvm.sh
source ~/.zshrc

## Install Node.js with NVM
nvm ls-remote
nvm install node     ## Installing Latest version
nvm install 14       ## Installing Node.js 14.X version
nvm ls
nvm use 14 

## Set default (or others)
nvm alias default 14

## Automatically switch node version when changing directory
if there is a .nvmrc file present in a directory, where you define a version, you can automaticcaly switch this version

Example .nvmrc file:
```md
v12.4.0
```

Add this to your zshrc file (or [see here](https://github.com/nvm-sh/nvm#deeper-shell-integration) for other shells)
```md
# export for using nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
# when changing directory... check if there is an nvmrc file.. if so... change version directly
autoload -U add-zsh-hook

load-nvmrc() {
local nvmrc_path
nvmrc_path="$(nvm_find_nvmrc)"

if [ -n "$nvmrc_path" ]; then
local nvmrc_node_version
nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
echo "Reverting to nvm default version"
nvm use default
fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
```
now if you switch, you get this output in your terminal:
```sh
~/Desktop $ cd ProjectWithNvmrcFile

Found '/Users/axel/Ravago/Projects/ims-office-front/.nvmrc' with version <v12.4.0>
Now using node v12.4.0 (npm v6.9.0)

~/Desktop $ cd ..

Reverting to nvm default version
Now using node v16.20.0 (npm v8.19.4)
```
