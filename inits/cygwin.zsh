# Cygwin Zsh Here
if [ "$OPEN_CYGWIN_FROM" != "" -a -x /bin/cygpath ]; then
#  OPEN_CYGWIN_FROM=$(echo $OPEN_CYGWIN_FROM | sed 's/\(^"\|"$\)//g')
    OPEN_CYGWIN_PATH=$(/bin/cygpath -u "$OPEN_CYGWIN_FROM")
    export OPEN_CYGWIN_PATH
    cd "$OPEN_CYGWIN_PATH"
fi
