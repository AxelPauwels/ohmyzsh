# pyenv

## Install pyenv

```sh
brew install pyenv
```

### Install python versions

```shell
pyenv install --list # check available versions
pyenv install --list | grep " 3\.[0-9]" # (check more specific)
pyenv install 2.7.18 # install a version
pyenv versions # check installed versions (copy one)
pyenv global 2.7.18 # set global (actually switch mode version at global level)
```

### Add to zsh file

```shell
nano ~/.zshrc
```

Add:

```md
eval "$(pyenv init --path)"
```

Restart your terminal

Check your python version:

```shell
python -V
```

## Other usefull commands

```sh
# To switch versions:
pyenv versions # (copy one)
pyenv global system
pyenv global 3.10.4

# To Uninstall:
pyenv uninstall 2.7.18
```

## More documentation

- [intro-to-pyenv](https://realpython.com/intro-to-pyenv/)
- [intro-to-pyenv-local](https://realpython.com/intro-to-pyenv/#local)
