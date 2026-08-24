# Installation Wizards
<img width="488" height="307" alt="image" src="https://github.com/user-attachments/assets/bf617b2b-8518-4326-915e-951eee894625" />
<br/>

<img width="470" height="189" alt="Screenshot 2026-08-24 at 16 53 25" src="https://github.com/user-attachments/assets/4fb40f6e-6215-4e68-bd8a-93a3d9e5ee3a" />

## Prerequisites
- A Unix-like operating system: macOS, Linux, BSD. 
- *Zsh* should be installed (v4.3.9 or more recent is fine but we prefer 5.0.8 and newer). If not pre-installed (run `zsh --version` to confirm), check the following wiki instructions here: [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- `Xcode CLI tools` should be installed
- `git` should be installed (recommended v2.4.11 or higher)

## Getting started
Download the resources:
```sh
git clone https://github.com/AxelPauwels/ohmyzsh.git ~/.oh-my-zsh
```
Run one of these scripts:
```sh
~/.oh-my-zsh/custom/installation/install.sh
```
```sh
~/.oh-my-zsh/custom/installation/install-more.sh
```
```sh
~/.oh-my-zsh/custom/installation/configure-powerlevel.sh
```

You can add these as aliases later if you want to easy access these installers next time:
```sh
alias zshInstall='~/.oh-my-zsh/custom/installation/install.sh'
alias zshInstallMore='~/.oh-my-zsh/custom/installation/install-more.sh'
alias zshInstallPowerlevel10k='~/.oh-my-zsh/custom/installation/configure-powerlevel.sh'
```

### Install.sh (Full or Partial install)
#### Zsh
_Just checks if zsh is installed. The installation of zsh is not developed yet_

#### Fonts
_Installs fonts to `~/Library/Fonts`. This will install `MesloLGS NF Regular` (recommended for powerlevelp10) and `Powerline` font-package._

_The powerline fonts-packages contains: 3270, Anonymice Powerline, Arimo for Powerline, Cousine for Powerline, DejaVu Sans Mono for Powerline, Droid Sans Mono for Powerline, Go Mono for Powerline, FuraMono-Regular Powerline, Go Mono for Powerline, Hack-Bold, Meslo LG for Powerline, MesloLGS NF, Monofur for Powerline, Noto Mono for Powerline, ProFont For Powerline, Roboto Mono for Powerline, Source Code Pro for Powerline, Space Mono for Powerline, SpaceMono-Bold, Symbol Neu for Powerline, Tinos for Powerline, Ubuntu Mono derivative Powerline,_

#### iTerm2
_Installs iTerm2 by `brew install --cask iterm2`. If brew is not installed, this will be installed before installing Warp._

#### iTerm2 color & font settings
_Sets the font to `MesloLGS NF Regular`, size to `13` (always use odd values here) and installs and sets our `Custom` color preset._

_These values can be found at iTerm2 > Settings > Profiles > Colors | Text_

#### Theme Powerlevel10k
_Installs the Powerlevel10k theme with configuration wizard. Warp does not support this yet. [See Warp-custom-prompt-compatibility](https://docs.warp.dev/features/prompt#custom-prompt-compatibility-table)_

#### Theme Agnoster
#### Warp
_Installs Warp by `brew install --cask warp`. If brew is not installed, this will be installed before installing Warp._

#### Warp Theme 'Custom'
_After installing this you schould set some preferences._
_Warp > Settings > Appearence > Click on 'current theme' > Select at bottom 'Custom' > click check-icon_
_Warp > Settings > Features > Session > Honor user's custom prompt (PS1)_

#### Zshrc
_Overrides ~/.zshrc file. (Note: Before overriding, there will be a backup file created of the existing `~/.zshrc` to `~/.zshrc.old`)_

### Install-more.sh
Xtools 
Homebrew
Pyenv
Mac Cursor speed
Mac Show hidden files in Finder (under construction)
GitHub Cli
Command 'tree'

### configure-powerlevel.sh
_Note: Currently not for Warp yet. (They are working on it)_

---

<p align="center"><img src="https://ohmyzsh.s3.amazonaws.com/omz-ansi-github.png" alt="Oh My Zsh"></p>

Check out the official [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) GitHub Repository for more documentation!
