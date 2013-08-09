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


zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'

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

#setopt autopushd
# cdの履歴を表示
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
# historyファイル
HISTFILE=~/.zsh_history
# ファイルサイズ
HISTSIZE=50000
# saveする量
SAVEHIST=50000
# 重複を記録しない
setopt hist_ignore_dups
# スペース排除
setopt hist_reduce_blanks
# 履歴ファイルを共有
setopt share_history
# zshの開始終了を記録
setopt EXTENDED_HISTORY
#先頭にスペースを入れると履歴に残さない
setopt hist_ignore_space


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
source $HOME/.zsh.d/aliases

# my functions
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls
    # ↓おすすめ
    # ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

function git-root() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `pwd`/`git rev-parse --show-cdup`
  fi
}

function tweet {
    echo $@ | tw --pipe --silent
}

function github {
    cd $HOME"/Develop/github"
    git clone git://github.com/$@.git
}
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function exists { which $1 &> /dev/null }

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)"

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

# Attache tmux
if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && which tmux > /dev/null; then
    if ( tmux has-session ); then
        session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
        if [ -n "$session" ]; then
            echo "Attache tmux session $session."
            tmux attach-session -t $session
        else
            echo "Session has been already attached."
            tmux list-sessions
        fi
    else
        echo "Create new tmux session."
        tmux
    fi
fi


# my functions on gist
source $HOME/.zsh.d/vendors/sources/gists/3965342/zsh-function-cd-source-dir.zsh
source $HOME/.zsh.d/vendors/sources/gists/5648186/JPG2jpg
