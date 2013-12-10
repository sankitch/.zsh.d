alias ls="ls --color"
alias open="gnome-open"

eval "$(rbenv init -)"

if [[ -f ~/.nodebrew/nodebrew ]]; then
    nodebrew use latest
fi

export PATH="$HOME/.pyenv/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
