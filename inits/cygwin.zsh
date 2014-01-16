SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
    ssh-add
fi

#
# aliases
#
alias -g open=cygstart
alias ls="ls -vF --color=auto --hide='NTUSER*' --hide='ntuser*'"
alias apt-cyg='apt-cyg -u -m ftp://ftp.iij.ad.jp/pub/cygwin/'
alias ec="emacsclientw"
alias mysql="mysql -h127.0.0.1"

function ipconfig {
    ipconfig.exe $@ | nkf -w
}

#
# Set environment variables
#
export LIBRARY_PATH=/usr/lib/w32api:$LIBRARY_PATH
