#!/usr/bin/env bash

# Bash History Handling

shopt -s histappend              # append to bash_history if Terminal.app quits
export HISTCONTROL=erasedups     # erase duplicates; alternative option: export HISTCONTROL=ignoredups
export HISTSIZE=5000             # resize history size
export AUTOFEATURE=true autotest #
export HIST_IGNORE_SPACE=1       # ignore commands prefixed with a space
export HIST_NO_STORE=1           # don't store `history` command
export HIST_NO_FUNCTIONS=1       # don't store function definitions

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
