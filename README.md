# DotFiles

These are my own **"dotfiles"** for Mac OS X, CentOS, and even a little Windows.

I've drawn on alot of resources from Github and the internet over the years to build this repo
so I take no credit for it at all.

Use at your own risk. I break things regularly and you should too.

## Resources

Here's the repos I leeched from. Forking was not really an option in these cases so I grabbed what was useful to me.

* [GitHub does dotfiles](https://dotfiles.github.io)
* [Zach Holman's dotfiles](https://github.com/holman/dotfiles)
* [Cowboy Mac/Linux Dotfiles](https://github.com/cowboy/dotfiles)
* [Mathias Bynen's dotfiles - great mac defaults](https://github.com/mathiasbynens/dotfiles)
* [yadr - yet another dotfile repo](https://github.com/skwp/dotfiles)
* [Bash It - community bash framework](https://github.com/Bash-it/bash-it)


Another option that doesn't involve github for keeping everything in sync is [Mackup](https://github.com/lra/mackup) which stores everything on the cloud drive of your choice. I use a combo of both because it keeps alot of app settings in sync nicely.

## Installation

This is customized to my liking so please read the init script before you run it. It does alot.

> I hope you backed up your existing files.

If you're me...


    cd $HOME
    git clone git@github.com:robmoggach/dotfiles.git ~/.dotfiles
    ./.dotfiles/init.sh

otherwise...

    cd $HOME
    git clone https://github.com/robmoggach/dotfiles.git ~/dotfiles
    ./.dotfiles/init.sh

It will ask you about vim stuff. It's installing vundle, a package manager for vim plugins at this point.
