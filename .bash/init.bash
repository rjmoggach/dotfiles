#!/usr/bin/env bash
# Initialize Bash

# Reload Library
case $OSTYPE in
  darwin*)
    alias reload='source ~/.bash_profile'
    ;;
  *)
    alias reload='source ~/.bashrc'
    ;;
esac

# Only set $BASH_INIT if it's not already set
if [ -z "$BASH_INIT" ]; then
    export BASH_INIT='${HOME}/.bash'
fi

# Load colors first so they can be use in theme
source "${BASH_INIT}/colors.bash"
source "${BASH_INIT}/theme.bash"

# library
LIB="${BASH_INIT}/lib/*.bash"
for config_file in $LIB; do
  source $config_file
done

# Load Jekyll stuff
if [ -e "$HOME/.jekyllconfig" ]
then
  . "$HOME/.jekyllconfig"
fi
