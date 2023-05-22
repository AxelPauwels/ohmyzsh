#!/usr/bin/env bash

command_exists() {
  if command -v "$@" >/dev/null 2>&1; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

app_exists() {
  if command -v "$1" >/dev/null 2>&1 || [[ -d "/Applications/$1.app" ]]; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

file_exists() {
  if [ -f "$1" ]; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

dir_exists() {
  if [ -d "$1" ]; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

# params: file_path  string
file_contains_string() {
  if grep -q "$2" "$1"; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

# params: file_path  string
#file_contains_string2() {
#      if strings "$1" | grep -q "$2"; then
#  return 0 # exist
#  else
#    return 1 # does not exist
#  fi
#}

# params: string  substring
string_contains_substring() {
  if [[ $1 == *"$2"* ]]; then
    return 0
  else
    return 1
  fi
}

toUpper() {
  if [ $# -eq 1 ]; then
    local uppercased=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    echo "$uppercased"
  else
    msg_error "This function expects exactly 1 parameter. None or too many are given."
  fi
}

toLower() {
  if [ $# -eq 1 ]; then
    local lowercased=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    echo "$lowercased"
  else
    msg_error "This function expects exactly 1 parameter. None or too many are given."
  fi
}
