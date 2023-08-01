# Variables
plugin_name='custom-ssh'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Private Functions (are not meant to be to call directly from CLI, but are more likely used in an alias
_sshCheckConnectionsAll() {
    echo "Checking user 'axel-pauwels_ravago'..."
    sshCheckConnectionRavago
    echo "Checking user 'com-ravago-sdc'..."
    sshCheckConnectionRavagoSDC
    echo "Checking user 'AxelPauwels'..."
    sshCheckConnectionPersonal
}

_sshResetKeys() {
    echo "Starting SSH agent..."
    eval "$(ssh-agent -s)" #(to start SSH agent)
    echo "Adding keys as identities..."
    ssh-add ~/.ssh/axel_ravago_id_rsa
    ssh-add ~/.ssh/id_ed25519
    echo "Checking identities (this should contain keys now)..."
    ssh-add -l
    echo ""
    echo "Checking connections..."
    _sshCheckConnectionsAll
}

# Aliases (this plugin)
alias zshCdPluginSsh="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginSsh="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginSsh="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
alias sshCheckIndentities='ssh-add -l'
alias sshCheckConnectionRavago='ssh -T git@github.com-axel-pauwels_ravago'
alias sshCheckConnectionRavagoSDC='ssh -T git@github.com-ravago-sdc'
alias sshCheckConnectionPersonal='ssh -T git@github.com-AxelPauwels'

# Function aliases
alias sshCheckConnections='_sshCheckConnectionsAll'
alias sshResetKeys='_sshResetKeys'
