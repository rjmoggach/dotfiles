#! /usr/bin/env bash
#
#
# ~/bin/dotfiles.sh
#
# an attempt at automating deployment of my dotfiles
#
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

DOTFILES=".dotfiles"
BACKUPDIR="${DOTFILES}/backup"
LINKFILES=( \
    '.bash_login' '.bash_profile' '.bash_prompt' '.bashrc' \
    '.curlrc' '.dir_colors' '.dircolors' '.editorconfig' '.exports'\
    '.gitconfig' '.gitignore_global' '.gvimrc' '.htoprc' '.hushlogin'\
    '.inputrc' '.pypirc' '.screenrc' '.viminfo' '.vimrc' '.wgetrc')
SYNCFILES=( \
    'bin/' '.bash/' '.vim/'
)

function PLATFORM() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        PLATFORM = 'LNX'
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM = 'MAC'
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        PLATFORM = 'WIN'
    elif [[ "$OSTYPE" == "msys" ]]; then
        PLATFORM = 'WIN'
    elif [[ "$OSTYPE" == "win32" ]]; then
        PLATFORM = 'WIN'
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        PLATFORM = 'MAC'
    else
        PLATFORM = 'UNKNOWN'
    fi
    echo $PLATFORM
}


function isdir() {
  if [[ ! -d $1 ]] && [[ ! -n $1 ]]; then
    return 1 # 1 is error 1 ie. false
  else
    return 0 # 0 is no error ie. true
  fi
}


function deploy_dotfiles() {
    if [ ! -d $1 ] && [ ! -n $1 ]; then
        mkdir $1
    fi
    for linkfile in "${LINKFILES[@]}"; do
        pushd $HOME
        if [ -L '~/${linkfile}' ]; then
            rm ${linkfile}
            echo "Linking ${linkfile}"
            echo "ln -s ${DOTFILES}/${linkfile} ${linkfile}"
        elif [ -f '~/${linkfile}' ]; then
            mv ${linkfile} ${DOTFILES}/backup/
            ln -s ${DOTFILES}/${linkfile} ${linkfile}
        else
            rm ${linkfile}
            ln -s ${DOTFILES}/${linkfile} ${linkfile}
        fi
        popd
    done
    for syncfile in "${SYNCFILES[@]}"; do
        pushd $HOME
        echo "Syncing ${syncfile}"
        if [[ -e '${syncfile}' ]]; then
            cp -Lr ${syncfile} ${DOTFILES}/backup/
            rsync --exclude ".git/" --exclude ".DS_Store" --exclude "init/" \
            --exclude ".gitignore" --exclude "reference" --exclude "backup" -avh --no-perms \
            ${DOTFILES}/${syncfile} ${syncfile}
        fi
        popd
    done
}


# MAIN
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    deploy_dotfiles $BACKUPDIR
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        deploy_dotfiles $BACKUPDIR
    fi
fi
. ~/.bash_profile
unset deploy_dotfiles

