#
# set prompt
#
autoload -Uz colors && colors
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

autoload -Uz compinit && compinit -u

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]

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
HISTFILE=~/.zsh_history
HISTSIZE=50000
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
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
bindkey "\e[Z" reverse-menu-complete

## zsh editor
autoload -Uz zed

## Alias configuration
#
# expand aliases before completing
# aliased ls needs if file/dir completions work
setopt complete_aliases

## terminal configuration
#case "${TERM}" in
#screen)
#    TERM=xterm
#    ;;
#esac

# set terminal title including current directory
#case "${TERM}" in
#xterm|xterm-color|kterm|kterm-color)
#    precmd() {
#        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#    }
#    ;;
#esac

# load inits file
case "${OSTYPE}" in
    cygwin)
        source $ZSH/inits/cygwin.zsh
        ;;
    freebsd*|darwin*)
        source $ZSH/inits/darwin.zsh
        ;;
    linux*)
        source $ZSH/inits/linux.zsh
        ;;
esac

# aliases
source $ZSH/aliases

# dircolors
eval `dircolors $ZSH/dircolors/solarized/dircolors.256dark`

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

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
    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

# Attache tmux
if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && exists tmux; then
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

[ -f $ZSH/zshrc_local ] && . $ZSH/zshrc_local
