# Cygwin Zsh Here
case "${OSTYPE}" in
cygwin)
    if [ "$OPEN_CYGWIN_FROM" != "" -a -x /bin/cygpath ]; then
    #  OPEN_CYGWIN_FROM=$(echo $OPEN_CYGWIN_FROM | sed 's/\(^"\|"$\)//g')
      OPEN_CYGWIN_PATH=$(/bin/cygpath -u "$OPEN_CYGWIN_FROM")
      export OPEN_CYGWIN_PATH
      cd "$OPEN_CYGWIN_PATH"
    fi
    ;;
esac

#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac


# PROMPT
#PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
PS1="[@${HOST%%.*} %1~]%(!.#.$) " # この辺は好み
RPROMPT="%T" # 右側に時間を表示する
setopt transient_rprompt # 右側まで入力がきたら時間を消す
setopt prompt_subst # 便利なプロンプト


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e # emacsライクなキーバインド
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

autoload -U compinit # 強力な補完機能
#compinit -u # このあたりを使わないとzsh使ってる意味なし
if [ "`/bin/uname -o 2> /dev/null`" = "Cygwin" ]; then
 # cygwinの設定
 compinit -u
elif [ "`/bin/uname -s 2> /dev/null`" = "Interix" ]; then
 # interixの設定
 compinit -u
else
 compinit
fi

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
#setopt autopushd # cdの履歴を表示
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# 同ディレクトリを履歴に追加しない
#
setopt pushd_ignore_dups

# 補完一覧ファイル種別表示
#
setopt list_types


## Command history configuration
#
HISTFILE=~/.zsh_history # historyファイル
HISTSIZE=50000 # ファイルサイズ
SAVEHIST=50000 # saveする量
setopt hist_ignore_dups # 重複を記録しない
setopt hist_reduce_blanks # スペース排除
setopt share_history # 履歴ファイルを共有
setopt EXTENDED_HISTORY # zshの開始終了を記録
setopt hist_ignore_space #先頭にスペースを入れると履歴に残さない


# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete

## zsh editor
#
autoload zed

## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"
alias screen="screen -U -s zsh"
alias sudo="sudo -E "

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
cygwin*)
    alias ls="ls -v -F --color=auto"
    alias -g open=cygstart
    alias apt-cyg='apt-cyg -u -m ftp://ftp.iij.ad.jp/pub/cygwin/'
    alias sudo="sudo"
    alias ec="emacsclientw -s sankitch-win7-server"
    alias mysql="mysql -h127.0.0.1"
    ;;
esac

alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias -g re="rbenv exec"
alias -g bi="bundle install --path=vendor/bundle --without production"
alias -g bu="bundle update"
alias -g be="bundle exec"

alias du="du -h"
alias df="df -h"

alias gcomp="curl -s http://getcomposer.org/installer | php"

alias su="su -l"

#alias diff="colordiff --side-by-side --suppress-common-lines"

## terminal configuration
#
case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac
#zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

function tweet {
    echo $@ | tw --pipe --silent
}

function rprompt-git-current-branch {
        local name st color

        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
                return
        fi
        name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
        if [[ -z $name ]]; then
                return
        fi
        st=`git status 2> /dev/null`
        if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
                color=${fg[green]}
        elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
                color=${fg[yellow]}
        elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
                color=${fg_bold[red]}
        else
                color=${fg[red]}
        fi

        # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
        # これをしないと右プロンプトの位置がずれる
        echo "%{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'

#anything-history ()  {
#    tmpfile=/tmp/.azh-tmp-file
#    emacsclient --eval '(anything-zsh-history-from-zle)' > /dev/null
#    zle -U "`cat $tmpfile`"
#    rm $tmpfile
#}
#zle -N anything-history
#bindkey "^R" anything-history

#if [[ -f ~/.nodebrew/nodebrew ]]; then
#    nodebrew use v0.8.2
#fi
#

# my functions
source $GISTY_DIR/3965335/zsh-function-cd-gisty-dir.zsh
source $GISTY_DIR/3965342/zsh-function-cd-source-dir.zsh
