#!/usr/bin/env bash

# If this file was being sourced, exit now.
[[ "$1" == "source" ]] && return

# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
function path_remove() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}

function PLATFORM() {
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
      echo 'LNX'
  elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo 'MAC'
  elif [[ "$OSTYPE" == "cygwin" ]]; then
      echo 'WIN'
  elif [[ "$OSTYPE" == "msys" ]]; then
      echo 'WIN'
  elif [[ "$OSTYPE" == "win32" ]]; then
      echo 'WIN'
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
      echo 'MAC'
  else
      echo 0
  fi
}

