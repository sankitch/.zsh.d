alias ls="ls --color"
alias open="gnome-open"

eval "$(rbenv init -)"

if [[ -f ~/.nodebrew/nodebrew ]]; then
    nodebrew use latest
fi
