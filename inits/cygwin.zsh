# Cygwin Zsh Here
if [ "$OPEN_CYGWIN_FROM" != "" -a -x /bin/cygpath ]; then
#  OPEN_CYGWIN_FROM=$(echo $OPEN_CYGWIN_FROM | sed 's/\(^"\|"$\)//g')
    OPEN_CYGWIN_PATH=$(/bin/cygpath -u "$OPEN_CYGWIN_FROM")
    export OPEN_CYGWIN_PATH
    cd "$OPEN_CYGWIN_PATH"
fi

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
    ssh-add
fi

# aliases
alias ls="ls -vF --color=auto --hide='NTUSER*' --hide='ntuser*'"
alias -g open=cygstart
alias apt-cyg='apt-cyg -u -m ftp://ftp.iij.ad.jp/pub/cygwin/'
alias sudo="sudo"
alias ec="emacsclient"
alias mysql="mysql -h127.0.0.1"

function ipconfig {
    ipconfig.exe $@ | nkf -w
}

export LIBRARY_PATH=/usr/lib/w32api:$LIBRARY_PATH

#[ ${STY} ] || screen -rx || screen -D -RR

#export JAVA_HOME=/winapp/java/jdk1.7.0_25
#export PATH=$JAVA_HOME/bin:$PATH
#export SCALA_HOME=/winapp/scala
#export PATH=$SCALA_HOME/bin:$PATH
#export PLAY_HOME=/winapp/play-2.1.3
#export PATH=$PLAY_HOME:$PATH

export WORKON_HOME=$HOME/Develop/pydev
source /usr/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
