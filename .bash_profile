#!/usr/bin/env bash
echo -ne "Sourcing "
echo -ne "${BASH_SOURCE[0]}\n"

export PATH="/usr/local/bin":"/usr/local/sbin":"${PATH}"
export PATH="${HOME}/bin":"${PATH}"
export PATH="/usr/local/opt/coreutils/libexec/gnubin":"${PATH}"

# Path to the bash init configuration
export BASH_INIT="${HOME}/.bash"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
DOTFILES=( 'bash_login'  'exports' 'aliases' 'functions' 'bash_completion' )

for file in ${DOTFILES[@]}; do
    file="${HOME}/.${file}"
    if [ -f $file ] || [ -L $file ]; then
        . $file
    fi
done;
unset file;

# Don't check mail when opening terminal.
unset MAILCHECK

# Load bash init
source $BASH_INIT/init.bash

# Load Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
