export SCALA_HOME=/usr/local/scala
export PLAY_HOME=/usr/local/play
export PATH=/bin:/opt/local/bin:/opt/local/sbin/:$HOME/bin:$HOME/.github/bin:$HOME/.nodebrew/current/bin:$HOME/scripts:/usr/local/heroku/bin:$HOME/.wp-cli/bin:$HOME/.rbenv/bin:$SCALA_HOME/bin:$PLAY_HOME:$PATH
export MANPATH=/opt/local/man:$MANPATH
export LANG=ja_JP.UTF-8 # 日本語環境
export LC_CTYPE=ja_JP.UTF-8 # 日本語環境
export PAGER=w3m
export GISTY_DIR=$HOME/Develop/gists
export GISTY_ACCESS_TOKEN=ac81117207155c85f34cac9e5732b22fba0856c4
export WWW_HOME=http://www.sankitch.me/
## Environment variable configuration
#
# LANG
#
case ${UID} in
0)
    LANG=C
    ;;
esac
export EDITOR=emacsclient
export GREP_COLOR="1;32"
export GREP_OPTIONS=--color=auto

## load function files
fpath=(~/.zsh.d/site-functions ${fpath})

ARCHNAME=$(perl -MConfig -e 'print $Config{archname}')
EXTLIB=./extlib/lib/perl5:./extlib/lib/perl5/$ARCHNAME
PERL5LIB=./lib:$EXTLIB

export PERL5LIB=$PERL5LIB
