
# HOME/PROJECTS: MOVIEREADER
alias readMovies='_aliasCommand "php ~/Documents/Home/Projects/MovieReaderApp/MovieReaderApp/readMovies.php"'


#############
# VARIABLES #
#############

IP_PROXYSERVER="192.168.0.10"
IP_MOVIESERVER="192.168.0.12"
IP_EASYHOST_TRAFFICAUTO="ssh.trafficauto.be"
USERNAME_EASYHOST_TRAFFICAUTO="trafficautobe"
IP_EASYHOST_SEPAGON="ssh.sepagon.be"
USERNAME_EASYHOST_SEPAGON="sepagonbe"



#########################
# FUNCTIONS FOR ALIASES #
#########################

# @params: [<username>] (the alias-name you want to find in all aliases)
# @options: [-help] shows more information about this command
# @return: executes the command "ssh <username>@${IP_PROXYSERVER}"
# @example: sshProxyserver root
#
_sshProxyserver() {
  if [ $# -eq 0 ]; then
    _messageCommand "ssh pi@${IP_PROXYSERVER}"
    _messageCommandInfo "Running with default parameter \"pi\". ${TEXT_MORE_INFO}"
  elif [ $# -eq 1 ]; then
    if [ $1 = "-help" ]; then      
      _messageCommandHelp -title "Command" "ssh <username>@${IP_PROXYSERVER}"
      _messageCommandHelp -title "Usage" "sshProxyserver [<username>] [-help]"
      _messageCommandHelp -title "Required parameters" "/" 
      _messageCommandHelp -title "Optional parameters" "<username> : The username to make the ssh connection. If this is omitted, the default username \"pi\" will be used instead." 
      _messageCommandHelp -title "Options" "-help : Shows more information about this command."
    else
      _messageCommand "ssh ${1}@${IP_PROXYSERVER}"
      ssh ${1}@${IP_PROXYSERVER}
    fi 
  else
    _messageError "This function expects maximum 1 optional parameter. Multiple are given. ${TEXT_MORE_INFO}"
  fi
}

# @params: [<username>] (the alias-name you want to find in all aliases)
# @options: [-help] shows more information about this command
# @return: executes the command "ssh <username>@${IP_MOVIESERVER}"
# @example: sshMovieserver root
#
_sshMovieserver() {
  if [ $# -eq 0 ]; then
    _messageCommand "ssh pi@${IP_MOVIESERVER}"
    _messageCommandInfo "Running with default parameter \"pi\". ${TEXT_MORE_INFO}"
  elif [ $# -eq 1 ]; then
    if [ $1 = "-help" ]; then
      _messageCommandHelp -title "Command" "ssh <username>@${IP_MOVIESERVER}"
      _messageCommandHelp -title "Usage" "sshMovieserver [<username>] [-help]"
      _messageCommandHelp -title "Required parameters" "/"
      _messageCommandHelp -title "Optional parameters" "<username> : The username to make the ssh connection. If this is omitted, the default username \"pi\" will be used instead."
      _messageCommandHelp -title "Options" "-help : Shows more information about this command."
    else
      _messageCommand "ssh ${1}@${IP_MOVIESERVER}"
      ssh ${1}@${IP_MOVIESERVER}
    fi
  else
    _messageError "This function expects maximum 1 optional parameter. Multiple are given. ${TEXT_MORE_INFO}"
  fi
}

# @params:
# @options: [-help] shows more information about this command
# @return: executes the command "ssh ${USERNAME_EASYHOST_TRAFFICAUTO}@${IP_EASYHOST_TRAFFICAUTO}"
# @example: sshEasyhostTrafficauto
#
_sshEasyhostTrafficauto() {
  if [ $# -eq 0 ]; then
      _messageCommand "ssh ${USERNAME_EASYHOST_TRAFFICAUTO}@${IP_EASYHOST_TRAFFICAUTO}"
      ssh ${USERNAME_EASYHOST_TRAFFICAUTO}@${IP_EASYHOST_TRAFFICAUTO}
  elif [ $# -eq 1 ]; then
    if [ $1 = "-help" ]; then
      _messageCommandHelp -title "Command" "ssh ${USERNAME_EASYHOST_TRAFFICAUTO}@${IP_EASYHOST_TRAFFICAUTO}"
      _messageCommandHelp -title "Usage" "sshEasyhostTrafficauto [-help]"
      _messageCommandHelp -title "Required parameters" "/"
      _messageCommandHelp -title "Optional parameters" "/"
      _messageCommandHelp -title "Options" "-help : Shows more information about this command."
      echo ""
      _messageInfo "If \"ssh.trafficauto.be\" doesn't work, temporarly use \"ssh041.webhosting.be\""
    else
      _messageError "Only option \"-help\" is expected. The given option doesn't match. ${TEXT_MORE_INFO}"
    fi
  else
    _messageError "This function expects maximum 1 option/parameters. Multiple are given. ${TEXT_MORE_INFO}"
  fi
}

# @params:
# @options: [-help] shows more information about this command
# @return: executes the command "ssh ${USERNAME_EASYHOST_SEPAGON}@${IP_EASYHOST_SEPAGON}"
# @example: "sshEasyhostSepagon"
#
_sshEasyhostSepagon() {
  if [ $# -eq 0 ]; then
    _messageCommand "ssh ${USERNAME_EASYHOST_SEPAGON}@${IP_EASYHOST_SEPAGON}"
    _messageCommandInfo "Using SSH-key to connect..."
    ssh ${USERNAME_EASYHOST_SEPAGON}@${IP_EASYHOST_SEPAGON}
  elif [ $# -eq 1 ]; then
    if [ $1 = "-help" ]; then
      _messageCommandHelp -title "Command" "ssh ${USERNAME_EASYHOST_SEPAGON}@${IP_EASYHOST_SEPAGON}"
      _messageCommandHelp -title "Usage" "sshEasyhostSepagon [-help]"
      _messageCommandHelp -title "Required parameters" "/"
      _messageCommandHelp -title "Optional parameters" "/"
      _messageCommandHelp -title "Options" "-help : Shows more information about this command."
      echo ""
      _messageInfo "If \"ssh.sepagon.be\" doesn't work, temporarly use \"ssh022.webhosting.be\""
    else
      _messageError "Only option \"-help\" expected. Given option doesn't match. ${TEXT_MORE_INFO}"
    fi
  else
    _messageError "This function expects maximum 1 option/parameters. Multiple are given. ${TEXT_MORE_INFO}"  
  fi
}

_sshKeyGenerate() {
  _messageCommand "ssh-keygen -t rsa"
  ssh-keygen -t rsa
}


_sshKeyAddIdentity() {
  if [ $# -eq 0 ]; then
    _messageError "This function expects minimum 1 parameters. This should be your private key from ~/.ssh/. Use command 'sshKeyShow' to see your keys."
  elif [ $# -eq 1 ]; then
    CONFIG_FILE=~/.ssh/config
    if [ ! -f "$CONFIG_FILE" ]; then
      _messageInfo "$CONFIG_FILE doesn't exists yet..."
      _messageInfo "Creating it now..."
      touch $CONFIG_FILE
      echo "Host *" >> $CONFIG_FILE
      echo "    UseKeychain yes" >> $CONFIG_FILE
      echo "    AddKeysToAgent yes" >> $CONFIG_FILE
      _messageFinish "Config file created!"
    fi
    _messageInfo "Adding key to config file..."
    _messageCommand "IdentityFile ~/.ssh/${1} >> $CONFIG_FILE"    
     echo "    IdentityFile ~/.ssh/${1}" >> $CONFIG_FILE
    _messageFinish "Done";
  else
    _messageError "This function expects maximum 1 option/parameters. Multiple are given."
  fi
}

_sskKeyCopy() {
  if [ $# -eq 0 ]; then
    _messageError "This function expects minimum 1 parameters. This should be your PUBLIC key from ~/.ssh/. Use command 'sshKeyShow' to see your keys."
  elif [ $# -eq 1 ]; then
    _messageCommand "pbcopy < ~/.ssh/${1}"
    pbcopy < ~/.ssh/${1}
  else
    _messageError "This function expects maximum 1 option/parameters. Multiple are given."
  fi
}

###########
# ALIASES #
###########

alias sshProxyserver=_sshProxyserver
alias sshMovieserver=_sshMovieserver
alias sshEasyhostTrafficauto=_sshEasyhostTrafficauto
alias sshEasyhostSepagon=_sshEasyhostSepagon

alias sshKeyShow='ls -la ~/.ssh'
alias sshKeyGenerate=_sshKeyGenerate
alias sshKeyAddIdentity=_sshKeyAddIdentity
alias sshKeyCopy=_sskKeyCopy
