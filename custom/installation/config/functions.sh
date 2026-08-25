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

get_repo_version() {
  local version_file="$HOME/.oh-my-zsh/VERSION"
  if [ -f "$version_file" ]; then
    tr -d '\r\n' <"$version_file"
  else
    echo "unknown"
  fi
}

read_menu_key() {
  local key
  local next_chars
  IFS= read -rsn1 key

  if [[ $key == $'\x1b' ]]; then
    IFS= read -rsn2 -t 1 next_chars || true
    key+="$next_chars"
  fi

  printf '%s' "$key"
}

print_radio_option() {
  local selected_index="$1"
  local option_index="$2"
  local option_label="$3"
  if [ "$selected_index" -eq "$option_index" ]; then
    msg "(◉) $option_label"
  else
    msg "(◯) $option_label"
  fi
}

# ============================================================================
# Interactive menu engine
# ----------------------------------------------------------------------------
# Renders a radio-button wizard pinned at the top of the screen. The output of
# the selected action is shown underneath the menu and is cleared as soon as
# another option is chosen (navigated to or activated again). Redraws use
# cursor positioning instead of a full screen clear, so the menu does not
# flicker, and check statuses are cached so navigation stays snappy.
#
# Callers set these globals (or locals, thanks to bash dynamic scope) before
# calling run_action_menu:
#   menu_title    : string shown bold at the top on every redraw
#   menu_header   : (optional) extra static lines shown under the title
#   menu_labels   : array of option labels
#   menu_checks   : (optional) array of check-function names (parallel)
#   menu_actions  : (optional) array of action-function names (parallel)
#   menu_hint     : (optional) footer hint
#   menu_selected : (optional) initial index; updated on return
#
# An action may set `menu_exit=1` to leave the menu (e.g. to hand off to a
# longer flow). On quit (q/Q) the engine sets `menu_quit=1`.
# ============================================================================

_menu_reset_screen() { printf '\033[2J\033[3J\033[H' >&2; }
_menu_home()         { printf '\033[H' >&2; }
_menu_clear_below()  { printf '\033[J' >&2; }
_menu_hide_cursor()  { printf '\033[?25l' >&2; }
_menu_show_cursor()  { printf '\033[?25h' >&2; }

run_action_menu() {
  local count=${#menu_labels[@]}
  local selected=${menu_selected:-0}
  local hint="${menu_hint:-Use ↑/↓ and Enter. Press q to quit.}"
  local key i marker status_line
  local -a _menu_status

  for ((i = 0; i < count; i++)); do
    if [ -n "${menu_checks[$i]:-}" ]; then
      _menu_status[$i]="$(${menu_checks[$i]} 2>&1)"
    else
      _menu_status[$i]=""
    fi
  done

  menu_quit=0
  menu_exit=0
  _menu_hide_cursor
  _menu_reset_screen

  while true; do
    _menu_home
    msg_title "$menu_title"
    new_line
    if [ -n "${menu_header:-}" ]; then
      msg "$menu_header"
      new_line
    fi
    for ((i = 0; i < count; i++)); do
      if [ "$selected" -eq "$i" ]; then marker="(◉)"; else marker="(◯)"; fi
      status_line="${_menu_status[$i]}"
      if [ -n "$status_line" ]; then
        msg " $marker ${menu_labels[$i]} $status_line"
      else
        msg " $marker ${menu_labels[$i]}"
      fi
    done
    msg ""
    msg_dimmed "$hint"
    msg_dimmed "────────────────────────────────────────────"

    # Cursor is now parked at the top of the output area (line after the hint).
    key=$(read_menu_key)
    case "$key" in
    $'\x1b[A')
      selected=$((selected - 1))
      [ "$selected" -lt 0 ] && selected=$((count - 1))
      _menu_clear_below
      ;;
    $'\x1b[B')
      selected=$((selected + 1))
      [ "$selected" -ge "$count" ] && selected=0
      _menu_clear_below
      ;;
    "" | $'\n' | $'\r')
      _menu_clear_below
      new_line
      _menu_show_cursor
      if [ -n "${menu_actions[$selected]:-}" ]; then
        "${menu_actions[$selected]}"
        msg_dimmed "Done. Continue in menu by using ↑/↓ and Enter or press q to quit."
      fi
      _menu_hide_cursor
      if [ -n "${menu_checks[$selected]:-}" ]; then
        _menu_status[$selected]="$(${menu_checks[$selected]} 2>&1)"
      fi
      [ "${menu_exit:-0}" -eq 1 ] && break
      ;;
    q | Q)
      menu_quit=1
      break
      ;;
    esac
  done

  _menu_show_cursor
  menu_selected=$selected
}
