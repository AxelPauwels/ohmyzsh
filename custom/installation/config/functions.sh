#!/usr/bin/env bash

command_exists() {
  if command -v "$@" >/dev/null 2>&1; then
    return 0 # exist
  else
    return 1 # does not exist
  fi
}

# Extracts the first version number (e.g. 1.2.3) from a string and prefixes "v".
# params: any string containing a version number
extract_version() {
  local v
  v="$(printf '%s' "$*" | grep -oE '[0-9]+(\.[0-9]+)+' | head -1)"
  if [ -n "$v" ]; then
    printf 'v%s' "$v"
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

# --- Lightweight loading spinner -------------------------------------------
# Shows an animated spinner on stderr while a slow step runs (e.g. probing
# installed versions before the menu is drawn).
_spinner_pid=""

start_spinner() {
  local message="${1:-Loading...}"
  _menu_hide_cursor
  (
    local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
    local i=0
    while true; do
      printf '\r%s %s' "${frames[i++ % ${#frames[@]}]}" "$message" >&2
      sleep 0.1
    done
  ) &
  _spinner_pid=$!
}

stop_spinner() {
  if [ -n "$_spinner_pid" ]; then
    kill "$_spinner_pid" >/dev/null 2>&1
    wait "$_spinner_pid" 2>/dev/null
    _spinner_pid=""
  fi
  printf '\r\033[K' >&2
}

# Signal-safe terminal restore. The menu engine hides the cursor; without this
# guard a Ctrl-C (SIGINT) or kill while the menu is drawn would leave the user's
# terminal with a permanently invisible cursor. Each top-level wizard calls this
# once, right after sourcing functions.sh, so the cursor is always restored on
# exit or interrupt no matter where the script dies.
install_cursor_guard() {
  trap 'stop_spinner; _menu_show_cursor' EXIT
  trap 'stop_spinner; _menu_show_cursor; exit 130' INT
  trap 'stop_spinner; _menu_show_cursor; exit 143' TERM
}

run_action_menu() {
  local count=${#menu_labels[@]}
  local selected=${menu_selected:-0}
  local hint="${menu_hint:-Use ↑/↓ and Enter. Press q to quit.}"
  local key i marker status_line
  local -a _menu_status

  start_spinner "Initializing wizard, checking installed versions…"
  for ((i = 0; i < count; i++)); do
    if [ -n "${menu_checks[$i]:-}" ]; then
      _menu_status[$i]="$(${menu_checks[$i]} 2>&1)"
    else
      _menu_status[$i]=""
    fi
  done
  stop_spinner

  menu_quit=0
  menu_exit=0
  _menu_hide_cursor
  _menu_reset_screen

  while true; do
    _menu_home
    local eol=$'\033[K'
    msg_title "$menu_title$eol"
    msg "$eol"
    if [ -n "${menu_header:-}" ]; then
      msg "$menu_header$eol"
      msg "$eol"
    fi
    for ((i = 0; i < count; i++)); do
      if [ "$selected" -eq "$i" ]; then marker="[◉]"; else marker=" ◯ "; fi
      status_line="${_menu_status[$i]}"
      if [ -n "$status_line" ]; then
        msg " $marker ${menu_labels[$i]} $status_line$eol"
      else
        msg " $marker ${menu_labels[$i]}$eol"
      fi
    done
    msg "$eol"
    if [ -n "${menu_footer:-}" ]; then
      msg "$menu_footer$eol"
      msg "$eol"
    fi
    msg_dimmed "$hint$eol"
    msg_dimmed "────────────────────────────────────────────$eol"

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
      menu_action_submenu=0
      if [ -n "${menu_actions[$selected]:-}" ]; then
        "${menu_actions[$selected]}"
        if [ "${menu_action_submenu:-0}" -ne 1 ]; then
          msg_dimmed "Done. Continue in menu by using ↑/↓ and Enter or press q to quit."
        fi
      fi
      _menu_hide_cursor
      if [ -n "${menu_checks[$selected]:-}" ]; then
        _menu_status[$selected]="$(${menu_checks[$selected]} 2>&1)"
      fi
      [ "${menu_exit:-0}" -eq 1 ] && break
      # A submenu action (its own run_action_menu) already ran its own interactive
      # screen; the user quit it deliberately, so return to this menu immediately
      # without an extra acknowledgement prompt.
      if [ "${menu_action_submenu:-0}" -eq 1 ]; then
        menu_quit=0
        _menu_reset_screen
        continue
      fi
      # Otherwise the action's output stays on screen until the user presses a
      # key. That output can be long enough to scroll the terminal, which would
      # move the menu's home position. So we read the acknowledgement key here
      # (while the output is still visible) and then do a FULL screen reset before
      # the loop redraws the menu — otherwise the pinned header lands mid-scroll
      # and the menu renders garbled/truncated.
      key=$(read_menu_key)
      case "$key" in
      $'\x1b[A')
        selected=$((selected - 1))
        [ "$selected" -lt 0 ] && selected=$((count - 1))
        ;;
      $'\x1b[B')
        selected=$((selected + 1))
        [ "$selected" -ge "$count" ] && selected=0
        ;;
      q | Q)
        menu_quit=1
        _menu_reset_screen
        break
        ;;
      esac
      _menu_reset_screen
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

# ============================================================================
# Pristine backup / restore helpers
# ----------------------------------------------------------------------------
# Installers snapshot a file/dir/defaults value ONCE (before their very first
# modification) so uninstall.sh can put things back exactly as they were.
# A snapshot is only taken if none exists yet, so the true pristine state is
# never overwritten by re-running an installer.
# ============================================================================

WIZARD_BACKUP_DIR="${WIZARD_BACKUP_DIR:-$HOME/.oh-my-zsh/custom/.wizard-backups}"

# has_backup <key>  -> returns 0 if a pristine snapshot exists
has_backup() {
  [ -e "$WIZARD_BACKUP_DIR/$1.state" ] || [ -e "$WIZARD_BACKUP_DIR/$1.defaults" ]
}

# backup_path <source_abs_path> <key>
backup_path() {
  local src="$1" key="$2"
  mkdir -p "$WIZARD_BACKUP_DIR"
  local marker="$WIZARD_BACKUP_DIR/$key.state"
  [ -e "$marker" ] && return 0 # already snapshotted; keep the pristine one

  if [ -d "$src" ]; then
    rm -rf "${WIZARD_BACKUP_DIR:?}/$key.dir"
    cp -R "$src" "$WIZARD_BACKUP_DIR/$key.dir"
    echo "dir" >"$marker"
  elif [ -e "$src" ]; then
    cp "$src" "$WIZARD_BACKUP_DIR/$key.file"
    echo "file" >"$marker"
  else
    echo "absent" >"$marker" # nothing existed before install
  fi
}

# restore_path <dest_abs_path> <key>
# Restores the pristine snapshot then clears it. If nothing was snapshotted,
# the destination is removed (best-effort clean-up).
restore_path() {
  local dest="$1" key="$2"
  local marker="$WIZARD_BACKUP_DIR/$key.state"

  if [ ! -e "$marker" ]; then
    rm -rf "$dest"
    return 0
  fi

  local state
  state="$(cat "$marker")"
  rm -rf "$dest"
  case "$state" in
  dir) cp -R "$WIZARD_BACKUP_DIR/$key.dir" "$dest" ;;
  file) cp "$WIZARD_BACKUP_DIR/$key.file" "$dest" ;;
  absent) : ;; # nothing existed before, leave it removed
  esac

  rm -rf "${WIZARD_BACKUP_DIR:?}/$key.state" "${WIZARD_BACKUP_DIR:?}/$key.file" "${WIZARD_BACKUP_DIR:?}/$key.dir"
}

# backup_defaults <domain> <key_name> <backup_key>
backup_defaults() {
  local domain="$1" dkey="$2" key="$3"
  mkdir -p "$WIZARD_BACKUP_DIR"
  local marker="$WIZARD_BACKUP_DIR/$key.defaults"
  [ -e "$marker" ] && return 0

  if defaults read "$domain" "$dkey" >/dev/null 2>&1; then
    local val type
    val="$(defaults read "$domain" "$dkey" 2>/dev/null)"
    type="$(defaults read-type "$domain" "$dkey" 2>/dev/null | sed 's/^Type is //')"
    {
      echo "present"
      echo "$type"
      echo "$val"
    } >"$marker"
  else
    echo "absent" >"$marker"
  fi
}

# restore_defaults <domain> <key_name> <backup_key>
restore_defaults() {
  local domain="$1" dkey="$2" key="$3"
  local marker="$WIZARD_BACKUP_DIR/$key.defaults"

  if [ ! -e "$marker" ]; then
    defaults delete "$domain" "$dkey" 2>/dev/null
    return 0
  fi

  local state type val
  state="$(sed -n '1p' "$marker")"
  if [ "$state" = "present" ]; then
    type="$(sed -n '2p' "$marker")"
    val="$(sed -n '3,$p' "$marker")"
    case "$type" in
    integer) defaults write "$domain" "$dkey" -int "$val" ;;
    boolean) defaults write "$domain" "$dkey" -bool "$val" ;;
    float) defaults write "$domain" "$dkey" -float "$val" ;;
    *) defaults write "$domain" "$dkey" -string "$val" ;;
    esac
  else
    defaults delete "$domain" "$dkey" 2>/dev/null
  fi

  rm -f "$marker"
}
