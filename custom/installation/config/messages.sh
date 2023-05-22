#!/usr/bin/env bash

new_line() {
  echo
}

msg_inline() {
  echo -en "$*" >&2
}
msg() {
  echo -e "$*" >&2
}

msg_title() {
  echo -e "${txt_bold}$*${txt_reset}" >&2
}

msg_italic() {
  echo -e "${txt_italic}$*${txt_reset}" >&2
}

msg_dimmed() {
  echo -e "${txt_dimmed}$*${txt_reset}" >&2
}

msg_url() {
  echo -e "${txt_blue}$*${txt_reset}" >&2
}

msg_success() {
  echo -e "${txt_green}${icon_check} ${txt_reset}$*" >&2
}

msg_warning() {
  echo -e "${txt_yellow}${icon_exclamation} ${txt_reset}$*" >&2
}

msg_error() {
  echo -e "${txt_red}${icon_times} ${txt_reset}$*" >&2
}

# for checking/looking/searching/doing
msg_searching() {
  echo -e "${txt_dimmed}${icon_arrow_right} $*${txt_reset}" >&2
}

# for found x/ x already exists/ x is done
msg_found() {
  echo -e "${txt_green}${txt_dimmed}${icon_check} $*${txt_reset}" >&2
}

msg_not_found() {
  echo -e "${txt_red}${txt_dimmed}${icon_times} $*${txt_reset}" >&2
}

msg_installed() {
  echo -e "${txt_green}${icon_check} $*${txt_reset}" >&2
}

msg_installed_no_icon() {
  echo -e "${txt_green}$*${txt_reset}" >&2
}

msg_warning_no_icon() {
  echo -e "${txt_yellow}$*${txt_reset}" >&2
}

msg_error_no_icon() {
  echo -e "${txt_red}$*${txt_reset}" >&2
}

# echo vs printf
# The difference between echo and printf command is that
# echo automatically adds a new line character at the end
# but for printf, you have to explicitly add it.
