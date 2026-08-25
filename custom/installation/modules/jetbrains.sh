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

# Guard: IDE present + build resolvable. Returns non-zero on failure.
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

# Install every missing plugin in one go.
_jetbrains_install_all() {
  msg_title "IntelliJ IDEA plugins"
  _jetbrains_precheck || return

  local installed missing_ids=() missing_names=() i
  installed=$(_jetbrains_installed_ids)
  for i in "${!_jetbrains_plugin_ids[@]}"; do
    msg_searching "Checking ${_jetbrains_plugin_names[$i]}"
    if grep -qxF "${_jetbrains_plugin_ids[$i]}" <<<"$installed"; then
      msg_found "Already installed"
    else
      msg_not_found "Not installed"
      missing_ids+=("${_jetbrains_plugin_ids[$i]}")
      missing_names+=("${_jetbrains_plugin_names[$i]}")
    fi
  done

  if [ ${#missing_ids[@]} -eq 0 ]; then
    new_line
    msg_installed "All plugins already installed"
    return
  fi

  new_line
  local ok=0
  for i in "${!missing_ids[@]}"; do
    if _jetbrains_download_plugin "${missing_ids[$i]}" "${missing_names[$i]}"; then
      ok=$((ok + 1))
    fi
  done

  new_line
  msg_installed "Installed $ok/${#missing_ids[@]} missing plugin(s). Restart IntelliJ IDEA to load them."
}

# Install a single plugin (skips if already installed).
_jetbrains_install_one() {
  local id="$1" name="$2"
  msg_title "Installing $name"
  _jetbrains_precheck || return

  if _jetbrains_plugin_installed "$id"; then
    msg_found "Already installed"
    return
  fi

  if _jetbrains_download_plugin "$id" "$name"; then
    new_line
    msg_installed "Restart IntelliJ IDEA to load $name."
  fi
}

# --- Per-plugin menu checks --------------------------------------------------
_jb_check() {
  if _jetbrains_plugin_installed "$1"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

c_jb_atom() { _jb_check "com.mallowigi"; }
c_jb_rain() { _jb_check "izhangzhihao.rainbow.brackets"; }
c_jb_copilot() { _jb_check "com.github.copilot"; }
c_jb_nx() { _jb_check "dev.nx.console"; }
c_jb_scss() { _jb_check "com.wix.scss.lint"; }
c_jb_spb() { _jb_check "manjaro.spb"; }

# --- Per-plugin menu actions -------------------------------------------------
i_jb_atom() { _jetbrains_install_one "com.mallowigi" "Atom Material Icons"; }
i_jb_rain() { _jetbrains_install_one "izhangzhihao.rainbow.brackets" "Rainbow Brackets"; }
i_jb_copilot() { _jetbrains_install_one "com.github.copilot" "GitHub Copilot"; }
i_jb_nx() { _jetbrains_install_one "dev.nx.console" "Nx Console"; }
i_jb_scss() { _jetbrains_install_one "com.wix.scss.lint" "Scss-lint"; }
i_jb_spb() { _jetbrains_install_one "manjaro.spb" "Sonic Progress Bar"; }

# --- Submenu -----------------------------------------------------------------
install_jetbrains_plugins() {
  local menu_title="IntelliJ IDEA plugins:"
  local menu_header=""
  local -a menu_labels=(
    "Install all missing plugins"
    "Atom Material Icons"
    "Rainbow Brackets"
    "GitHub Copilot"
    "Nx Console"
    "Scss-lint"
    "Sonic Progress Bar"
  )
  local -a menu_checks=(
    ""
    "c_jb_atom"
    "c_jb_rain"
    "c_jb_copilot"
    "c_jb_nx"
    "c_jb_scss"
    "c_jb_spb"
  )
  local -a menu_actions=(
    "_jetbrains_install_all"
    "i_jb_atom"
    "i_jb_rain"
    "i_jb_copilot"
    "i_jb_nx"
    "i_jb_scss"
    "i_jb_spb"
  )
  local menu_selected=0
  run_action_menu
  clear
  menu_action_submenu=1
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
