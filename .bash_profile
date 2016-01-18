#!/usr/bin/env bash

export PATH="/usr/local/bin":"/usr/local/sbin":"${PATH}"
export PATH="${HOME}/bin":"${PATH}"
export PATH="/usr/local/opt/coreutils/libexec/gnubin":"${PATH}"

# Path to the bash init configuration
export BASH_INIT="$HOME/.bash"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
DOTFILES=( 'bash_login' 'bash_prompt' 'exports' 'aliases' 'functions' 'bash_completion' )

for file in "~/.${DOTFILES[@]}"; do
    [ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true




# Load bash init
source $BASH_INIT/init.bash
