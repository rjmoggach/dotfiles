# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Case-insensitive matching while executing case or [[ statements
shopt -s nocasematch;

# files beginning with a '.' are included in filename expansion
shopt -s dotglob;


# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;
