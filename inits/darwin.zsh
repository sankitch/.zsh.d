if [ -f ~/.phpenv/bin/phpenv ]; then
    export PATH=$PATH:~/.phpenv/bin
    eval "$(phpenv init -)"
fi
PHP_VERSIONS=$HOME/.phpenv/versions
export PHP_HOME=$HOME/.phpenv/versions
source $(brew --prefix php-version)/php-version.sh && php-version 5.2.17 >/dev/null
