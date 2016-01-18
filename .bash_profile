# Add `~/bin` to the `$PATH`
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH="$HOME/bin:$PATH";
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

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

