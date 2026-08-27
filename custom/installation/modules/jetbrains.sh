#!/usr/bin/env bash

# ============================================================================
# JetBrains IntelliJ IDEA plugins
# ----------------------------------------------------------------------------
# Installs a curated set of IntelliJ IDEA plugins by downloading them straight
# from the JetBrains Marketplace and dropping them into the IDE's plugins
# directory. The new plugins are picked up the next time IntelliJ is restarted.
#
# This approach works WHILE IntelliJ is running (which matters because the
# wizard is often launched from IntelliJ's own integrated terminal) and does
# not rely on the `idea installPlugins` CLI, which refuses to run while the IDE
# is open.
#
# Download endpoint (returns the latest version compatible with the given IDE
# build, as either a plugin .zip or a bare .jar):
#   https://plugins.jetbrains.com/pluginManager?action=download&id=<id>&build=IU-<build>
# ============================================================================

_jetbrains_app="/Applications/IntelliJ IDEA.app"

# Curated plugins (parallel arrays: id <-> human readable name).
_jetbrains_plugin_ids=(
  "com.mallowigi"
  "izhangzhihao.rainbow.brackets"
  "com.github.copilot"
  "dev.nx.console"
  "com.wix.scss.lint"
  "manjaro.spb"
)
_jetbrains_plugin_names=(
  "Atom Material Icons"
  "Rainbow Brackets"
  "GitHub Copilot"
  "Nx Console"
  "Scss-lint"
  "Sonic Progress Bar"
)

# Latest IntelliJ IDEA config directory (e.g. .../JetBrains/IntelliJIdea2026.2).
_jetbrains_config_dir() {
  local base="$HOME/Library/Application Support/JetBrains"
  ls -d "$base"/IntelliJIdea* 2>/dev/null | sort -V | tail -1
}

# Plugins directory inside the latest config dir.
_jetbrains_plugins_dir() {
  local cfg
  cfg=$(_jetbrains_config_dir)
  [ -n "$cfg" ] && printf '%s/plugins\n' "$cfg"
}

# IDE build id in the "IU-262.9437.185" form the Marketplace expects.
_jetbrains_build() {
  local pi="$_jetbrains_app/Contents/Resources/product-info.json"
  [ -f "$pi" ] || return 1
  local code build
  code=$(grep -o '"productCode"[[:space:]]*:[[:space:]]*"[^"]*"' "$pi" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
  build=$(grep -o '"buildNumber"[[:space:]]*:[[:space:]]*"[^"]*"' "$pi" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
  [ -n "$code" ] && [ -n "$build" ] || return 1
  printf '%s-%s\n' "$code" "$build"
}

# Echo the plugin id of every installed plugin (one per line).
_jetbrains_installed_ids() {
  local dir
  dir=$(_jetbrains_plugins_dir)
  [ -d "$dir" ] || return
  local p jar id
  for p in "$dir"/*; do
    [ -e "$p" ] || continue
    if [ -d "$p" ]; then
      for jar in "$p"/lib/*.jar "$p"/*.jar; do
        [ -e "$jar" ] || continue
        id=$(unzip -p "$jar" META-INF/plugin.xml 2>/dev/null | grep -m1 -o '<id>[^<]*</id>')
        if [ -n "$id" ]; then
          id=${id#<id>}; id=${id%</id>}
          echo "$id"; break
        fi
      done
    elif [[ "$p" == *.jar ]]; then
      id=$(unzip -p "$p" META-INF/plugin.xml 2>/dev/null | grep -m1 -o '<id>[^<]*</id>')
      if [ -n "$id" ]; then
        id=${id#<id>}; id=${id%</id>}
        echo "$id"
      fi
    fi
  done
}

# Is a single plugin id installed?
_jetbrains_plugin_installed() {
  local ids
  ids=$(_jetbrains_installed_ids)
  grep -qxF "$1" <<<"$ids"
}

# Download a plugin from the Marketplace and install it into the plugins dir.
# $1 = plugin id, $2 = human name. Returns 0 on success.
_jetbrains_download_plugin() {
  local id="$1" name="$2"
  local dir build
  dir=$(_jetbrains_plugins_dir)
  build=$(_jetbrains_build)

  if [ -z "$dir" ]; then
    msg_error "Could not locate the IntelliJ IDEA plugins directory"
    return 1
  fi
  if [ -z "$build" ]; then
    msg_error "Could not determine the IntelliJ IDEA build number"
    return 1
  fi
  mkdir -p "$dir"

  local url="https://plugins.jetbrains.com/pluginManager?action=download&id=${id}&build=${build}"
  local tmp; tmp=$(mktemp -d "${TMPDIR:-/tmp}/jbplugin.XXXXXX")
  local dl="$tmp/plugin.download"

  msg_searching "Downloading $name"
  local info code effurl
  info=$(curl -sSL -o "$dl" "$url" -w '%{http_code} %{url_effective}') || {
    msg_error "Download failed for $name"
    rm -rf "$tmp"; return 1
  }
  code=${info%% *}
  effurl=${info#* }

  if [ "$code" != "200" ] || [ ! -s "$dl" ]; then
    msg_error "Marketplace returned HTTP $code for $name"
    rm -rf "$tmp"; return 1
  fi

  local fname; fname=$(basename "${effurl%%\?*}")
  msg_searching "Installing $name into plugins directory"
  case "$fname" in
  *.jar)
    if cp "$dl" "$dir/$fname"; then
      msg_installed "$name installed"
    else
      msg_error "Failed to copy $name"
      rm -rf "$tmp"; return 1
    fi
    ;;
  *)
    # Plugin distribution zip: unzip into the plugins directory.
    if unzip -oq "$dl" -d "$dir"; then
      msg_installed "$name installed"
    else
      msg_error "Failed to unpack $name"
      rm -rf "$tmp"; return 1
    fi
    ;;
  esac

  rm -rf "$tmp"
  return 0
}

# Echo the on-disk path (plugin dir or bare .jar) for a given plugin id.
_jetbrains_plugin_path() {
  local want="$1" dir p jar id
  dir=$(_jetbrains_plugins_dir)
  [ -d "$dir" ] || return
  for p in "$dir"/*; do
    [ -e "$p" ] || continue
    if [ -d "$p" ]; then
      for jar in "$p"/lib/*.jar "$p"/*.jar; do
        [ -e "$jar" ] || continue
        id=$(unzip -p "$jar" META-INF/plugin.xml 2>/dev/null | grep -m1 -o '<id>[^<]*</id>')
        if [ -n "$id" ]; then
          id=${id#<id>}; id=${id%</id>}
          [ "$id" = "$want" ] && { echo "$p"; return; }
          break
        fi
      done
    elif [[ "$p" == *.jar ]]; then
      id=$(unzip -p "$p" META-INF/plugin.xml 2>/dev/null | grep -m1 -o '<id>[^<]*</id>')
      if [ -n "$id" ]; then
        id=${id#<id>}; id=${id%</id>}
        [ "$id" = "$want" ] && { echo "$p"; return; }
      fi
    fi
  done
}

# Remove an installed plugin from disk. $1 = plugin id, $2 = human name.
_jetbrains_remove_plugin() {
  local id="$1" name="$2" path
  path=$(_jetbrains_plugin_path "$id")
  if [ -z "$path" ]; then
    msg_warning "$name not found on disk"
    return 1
  fi
  msg_searching "Removing $name"
  if rm -rf "$path"; then
    msg_installed "$name removed"
    return 0
  fi
  msg_error "Failed to remove $name"
  return 1
}
_jetbrains_precheck() {
  if [ ! -d "$_jetbrains_app" ]; then
    msg_error "IntelliJ IDEA not found at $_jetbrains_app"
    return 1
  fi
  if [ -z "$(_jetbrains_build)" ]; then
    msg_error "Could not read IntelliJ IDEA build number"
    return 1
  fi
  return 0
}

# --- Submenu -----------------------------------------------------------------
# Checkbox-style plugin manager (mirrors the Powerlevel10k segments menu).
# Checked = plugin should be installed. On save, plugins toggled on that are
# missing get downloaded, and plugins toggled off that are present get removed.
install_jetbrains_plugins() {
  if [ ! -d "$_jetbrains_app" ]; then
    msg_title "IntelliJ IDEA plugins"
    msg_error "IntelliJ IDEA not found at $_jetbrains_app"
    new_line
    msg_dimmed "Press any key to return."
    read_menu_key >/dev/null
    menu_action_submenu=1
    return
  fi

  local n=${#_jetbrains_plugin_ids[@]}
  local -a seg_state seg_initial
  local installed i

  start_spinner "Checking installed IntelliJ IDEA plugins…"
  installed=$(_jetbrains_installed_ids)
  for ((i = 0; i < n; i++)); do
    if grep -qxF "${_jetbrains_plugin_ids[$i]}" <<<"$installed"; then
      seg_state[$i]=1
    else
      seg_state[$i]=0
    fi
    seg_initial[$i]=${seg_state[$i]}
  done
  stop_spinner

  local selected=0
  local save_index=$n
  local eol=$'\033[K'
  local key cursor box

  _menu_hide_cursor
  _menu_reset_screen
  while true; do
    _menu_home
    msg_title "IntelliJ IDEA plugins$eol"
    msg "$eol"
    msg_dimmed "Toggle plugins on/off. Checked = installed. Save installs missing and removes unchecked.$eol"
    msg "$eol"

    for ((i = 0; i < n; i++)); do
      cursor="  "
      [ "$selected" -eq "$i" ] && cursor="➤ "
      if [ "${seg_state[$i]}" -eq 1 ]; then box="[x]"; else box="[ ]"; fi
      msg " $cursor$box ${_jetbrains_plugin_names[$i]}$eol"
    done

    msg "$eol"
    cursor="  "
    [ "$selected" -eq "$save_index" ] && cursor="➤ "
    msg " ${cursor}✔ Save & apply$eol"
    msg "$eol"
    msg_dimmed "↑/↓ move · Space/Enter toggle · Enter on Save to confirm · q to cancel$eol"
    _menu_clear_below

    key=$(read_menu_key)
    case "$key" in
    $'\x1b[A')
      selected=$((selected - 1))
      [ "$selected" -lt 0 ] && selected=$save_index
      ;;
    $'\x1b[B')
      selected=$((selected + 1))
      [ "$selected" -gt "$save_index" ] && selected=0
      ;;
    " ")
      if [ "$selected" -lt "$n" ]; then
        seg_state[$selected]=$((1 - seg_state[$selected]))
      fi
      ;;
    "" | $'\n' | $'\r')
      if [ "$selected" -lt "$n" ]; then
        seg_state[$selected]=$((1 - seg_state[$selected]))
      else
        _menu_clear_below
        new_line
        _menu_show_cursor

        local changed=0 j
        for ((j = 0; j < n; j++)); do
          [ "${seg_state[$j]}" -ne "${seg_initial[$j]}" ] && changed=1
        done
        if [ "$changed" -eq 0 ]; then
          msg_warning "No changes to apply."
          break
        fi

        printf '%s' "Apply changes to IntelliJ IDEA plugins? (y/N): " >&2
        local confirm
        IFS= read -rsn1 confirm
        printf '%s\n' "$confirm" >&2
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
          msg_warning "No changes applied."
          break
        fi

        new_line
        if ! _jetbrains_precheck; then
          new_line
          msg_dimmed "Press any key to return."
          read_menu_key >/dev/null
          break
        fi

        local ok=0 fail=0
        for ((j = 0; j < n; j++)); do
          [ "${seg_state[$j]}" -eq "${seg_initial[$j]}" ] && continue
          if [ "${seg_state[$j]}" -eq 1 ]; then
            if _jetbrains_download_plugin "${_jetbrains_plugin_ids[$j]}" "${_jetbrains_plugin_names[$j]}"; then
              ok=$((ok + 1))
            else
              fail=$((fail + 1))
            fi
          else
            if _jetbrains_remove_plugin "${_jetbrains_plugin_ids[$j]}" "${_jetbrains_plugin_names[$j]}"; then
              ok=$((ok + 1))
            else
              fail=$((fail + 1))
            fi
          fi
        done

        new_line
        if [ "$fail" -eq 0 ]; then
          msg_installed "Applied $ok change(s). Restart IntelliJ IDEA to load them."
        else
          msg_warning "Applied $ok change(s), $fail failed. Restart IntelliJ IDEA to load them."
        fi
        break
      fi
      ;;
    q | Q)
      msg_warning "No changes applied."
      break
      ;;
    esac
  done

  _menu_show_cursor
  menu_action_submenu=1
}

# Non-interactive install used by "Install all": if IntelliJ IDEA is present,
# install every curated plugin (equivalent to checking all boxes and saving);
# if it is not installed, skip quietly.
install_jetbrains_plugins_all() {
  new_line
  msg_title "IntelliJ IDEA plugins"

  if [ ! -d "$_jetbrains_app" ]; then
    msg_dimmed "IntelliJ IDEA not found, skipping."
    return
  fi
  if ! _jetbrains_precheck; then
    return
  fi

  local n=${#_jetbrains_plugin_ids[@]}
  local installed i ok=0 fail=0 skip=0
  start_spinner "Checking installed IntelliJ IDEA plugins…"
  installed=$(_jetbrains_installed_ids)
  stop_spinner

  for ((i = 0; i < n; i++)); do
    if grep -qxF "${_jetbrains_plugin_ids[$i]}" <<<"$installed"; then
      msg_found "${_jetbrains_plugin_names[$i]} already installed"
      skip=$((skip + 1))
    elif _jetbrains_download_plugin "${_jetbrains_plugin_ids[$i]}" "${_jetbrains_plugin_names[$i]}"; then
      ok=$((ok + 1))
    else
      fail=$((fail + 1))
    fi
  done

  new_line
  if [ "$fail" -eq 0 ]; then
    msg_installed "Installed $ok plugin(s), $skip already present. Restart IntelliJ IDEA to load them."
  else
    msg_warning "Installed $ok plugin(s), $skip already present, $fail failed. Restart IntelliJ IDEA to load them."
  fi
}

# Top-level status shown next to the "Jetbrains IntelliJ Plugins" menu item.
check_install_jetbrains() {
  if [ ! -d "$_jetbrains_app" ]; then
    msg_not_found "IntelliJ IDEA not found"
    return
  fi

  local installed total=${#_jetbrains_plugin_ids[@]} count=0 id
  installed=$(_jetbrains_installed_ids)
  for id in "${_jetbrains_plugin_ids[@]}"; do
    grep -qxF "$id" <<<"$installed" && count=$((count + 1))
  done

  if [ "$count" -eq 0 ]; then
    msg_not_found "Not installed (0/$total)"
  else
    msg_found "Installed ($count/$total)"
  fi
}
