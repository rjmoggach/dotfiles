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

rsync () {
    command rsync "$@" > /dev/null
}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


DOTFILES=".dotfiles"
TIMESTAMP=$(date +"%y%m%d_%H%M%S")
BACKUPDIR="${DOTFILES}/backup/${TIMESTAMP}"

LINKFILES=( \
    '.bash_login' '.bash_profile' '.bash_prompt' '.bashrc' \
    '.curlrc' '.dir_colors' '.dircolors' '.editorconfig' '.exports'\
    '.gitconfig' '.gitignore_global' '.gvimrc' '.htoprc' '.hushlogin'\
    '.mackup.cfg' '.inputrc' '.screenrc' '.viminfo' '.vimrc' '.wgetrc')
SYNCDIRS=( \
    'bin/' '.bash/' '.vim'
)
COPYFILES=(\
    '.pypirc'
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
    echo -ne "\nLinking"
    for linkfile in "${LINKFILES[@]}"; do
        pushd $HOME
        if [ -L ${linkfile} ]; then
            rm ${linkfile}
            echo -ne " ${linkfile}"
            ln -s ${DOTFILES}/${linkfile} ${linkfile}
        elif [ -f '~/${linkfile}' ]; then
            mv ${linkfile} ${BACKUPDIR}/
            ln -s ${DOTFILES}/${linkfile} ${linkfile}
        else
            rm ${linkfile}
            ln -s ${DOTFILES}/${linkfile} ${linkfile}
        fi
        popd
        sleep 0.1
    done
    echo -ne "\n\nSyncing"
    for syncdir in "${SYNCDIRS[@]}"; do
        pushd $HOME
        if [ -d ${syncdir} ]; then
            cp -r ${syncdir} ${BACKUPDIR}/
        elif [ -L ${syncdir} ]; then
            cp -L ${syncdir} ${BACKUPDIR}/
        else
            mkdir ${syncdir}
        fi
        echo -ne " ${syncdir}"
        rsync --exclude ".git/" --exclude ".DS_Store" \
            --exclude "init/" --exclude ".gitignore" \
            --exclude "reference" --exclude "backup" \
            -avh --no-perms \
            ${DOTFILES}/${syncdir}/ ${syncdir}/
        popd
    done
    echo -ne "\n\nCopying"
    for file in "${COPYFILES[@]}"; do
        pushd $HOME
        echo -ne " ${file}"
        if [ -f ${file} ]; then
            cp ${file} ${BACKUPDIR}/
        else
            rm ${file}
            cp ${DOTFILES}/${file} ${file}
        fi
        popd
        sleep 0.2
    done
    echo -ne '\n\nDone.\n'
}


function deploy_vim() {
    pushd $HOME
    read -p "Do you want to install the custom vim stuff? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -d ~/.vim ]; then
            cp -r ~/.vim $BACKUPDIR/
        else
            mkdir ~/.vim
        fi
        rsync --exclude ".git/" --exclude ".DS_Store" \
            --exclude "init/" --exclude ".gitignore" \
            --exclude "reference" --exclude "backup" \
            -avh --no-perms \
            ${DOTFILES}/.vim/ ${HOME}/.vim/
        if [ ! -d ~/.vim/bundle/vundle ]; then
            git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
            echo -ne "When you run vim use the following command string:\n\n\
    vim --noplugin -u .vim/vundles.vim -N \"+set hidden\" \"+syntax on\" +BundleClean! +BundleInstall +qall\n"
        else
            echo -ne "\n    Already installed.\n"
        fi
    fi
    popd

}

# MAIN
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    mkdir -p $BACKUPDIR
    deploy_dotfiles $BACKUPDIR
    deploy_vim
else
    mkdir -p $BACKUPDIR
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        deploy_dotfiles $BACKUPDIR
        deploy_vim
    fi
fi
source ~/.bash_profile
unset deploy_dotfiles
