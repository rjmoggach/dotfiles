
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Robert Moggach"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="rob@moggach.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"

export GIT_AUTHOR_NAME
export GIT_AUTHOR_EMAIL
export GIT_COMMITTER_NAME
export GIT_COMMITTER_EMAIL