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
PS1="[@${HOST%%.*} %1~]%(!.#.$) "

# 右側に時間を表示する
RPROMPT="%T"

# 右側まで入力がきたら時間を消す
setopt transient_rprompt

# 便利なプロンプト
setopt prompt_subst


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#

# emacsライクなキーバインド
bindkey -e
# Home gets to line head
bindkey "^[[1~" beginning-of-line
# End gets to line end
bindkey "^[[4~" end-of-line
# Del
bindkey "^[[3~" delete-char

# 強力な補完機能
autoload -U compinit
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
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]

#setopt autopushd # cdの履歴を表示
setopt auto_pushd

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

# 同ディレクトリを履歴に追加しない
setopt pushd_ignore_dups

# 補完一覧ファイル種別表示
setopt list_types


## Command history configuration
HISTFILE=~/.zsh_history # historyファイル
HISTSIZE=50000 # ファイルサイズ
SAVEHIST=50000 # saveする量
setopt hist_ignore_dups # 重複を記録しない
setopt hist_reduce_blanks # スペース排除
setopt share_history # 履歴ファイルを共有
setopt EXTENDED_HISTORY # zshの開始終了を記録
setopt hist_ignore_space #先頭にスペースを入れると履歴に残さない


# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
bindkey "\e[Z" reverse-menu-complete

## zsh editor
autoload zed

## Alias configuration
#
# expand aliases before completing
# aliased ls needs if file/dir completions work
setopt complete_aliases

## terminal configuration
case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

# set terminal title including current directory
case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

RPROMPT='[`rprompt-git-current-branch`%~]'

#if [[ -f ~/.nodebrew/nodebrew ]]; then
#    nodebrew use v0.8.2
#fi

# load inits file
case "${OSTYPE}" in
    cygwin)
        source $HOME/.zsh.d/inits/cygwin.zsh
        ;;
    freebsd*|darwin*)
        source $HOME/.zsh.d/inits/darwin.zsh
        ;;
    linux*)
        source $HOME/.zsh.d/inits/linux.zsh
        ;;
esac


# aliases
# global
alias -g re="rbenv exec"
alias -g bi="bundle install --path=vendor/bundle --without production"
alias -g bu="bundle update"
alias -g be="bundle exec"
alias -g PE="| percol --match-method=migemo"

# aliases
alias where="command -v"
alias j="jobs -l"
alias screen="screen -U -s zsh"
alias sudo="sudo -E "
alias github="cd ~/.github; git"

alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

alias du="du -h"
alias df="df -h"

alias gcomp="curl -s http://getcomposer.org/installer | php"

alias su="su -l"

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

# my functions
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

function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac=gtac || tac=tac
        BUFFER=$($tac $HISTFILE | sed 's/^: [0-9]*:[0-9]*;//' | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history

    source $HOME/.zsh.d/vendors/sources/gists/3982188/change-directory-gisty-by-percol.zsh
    source $HOME/.zsh.d/vendors/sources/gists/3981972/search-document-by-percol.zsh
fi


# my functions on gist
source $HOME/.zsh.d/vendors/sources/gists/3965342/zsh-function-cd-source-dir.zsh
