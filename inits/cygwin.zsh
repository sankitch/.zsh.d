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
alias ls="ls -v -F --color=auto --hide='NTUSER*' --hide='ntuser*'"
alias -g open=cygstart
alias apt-cyg='apt-cyg -u -m ftp://ftp.iij.ad.jp/pub/cygwin/'
alias sudo="sudo"
alias ec="emacsclientw -s sankitch-win7z-server"
alias mysql="mysql -h127.0.0.1"
alias vim="gvim"

function ipconfig {
    ipconfig.exe $@ | nkf -w
}


export LIBRARY_PATH=/usr/lib/w32api:$LIBRARY_PATH

[ ${STY} ] || screen -rx || screen -D -RR

