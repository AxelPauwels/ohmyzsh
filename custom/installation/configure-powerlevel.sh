#!/usr/bin/env bash

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/"
ZSH_INSTALL="$HOME/.oh-my-zsh/custom/installation"

###########
# IMPORTS #
###########
chmod 755 "$ZSH_INSTALL"/config/variables.sh && source "$ZSH_INSTALL"/config/variables.sh
chmod 755 "$ZSH_INSTALL"/config/functions.sh && source "$ZSH_INSTALL"/config/functions.sh
chmod 755 "$ZSH_INSTALL"/config/messages.sh && source "$ZSH_INSTALL"/config/messages.sh

# Always restore the cursor on exit/interrupt (the menu engine hides it).
install_cursor_guard

#############
# FUNCTIONS #
#############
_configure_p10k_wizard() {
  p10k_state_set install full
  p10k_state_set customized 0
  rm -rf "$HOME/.p10k.zsh" # Need to be deleted, otherwise the wizard script (p10k configure) will not be started
  exec zsh -ic 'p10k configure; exec zsh'
}

_configure_p10k_preset() {
  p10k_action_ran=1
  p10k_state_set install axel
  p10k_state_set customized 0
  cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$HOME/"
  msg_success "Applied Axel's Powerlevel10k configuration preset."
  msg_dimmed "Restart your terminal (or run 'source ~/.p10k.zsh') to see the changes."
}

_configure_p10k_nickname() {
  p10k_action_ran=1
  p10k_config="$HOME/.p10k.zsh"
  if [ ! -f "$p10k_config" ]; then
    cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$p10k_config"
  fi

  read -r -p "Enter username/nickname: " p10k_nickname
  temp_p10k_config=$(mktemp)
  if awk -v nickname="$p10k_nickname" '
    /^[[:space:]]*#/ { print; next }
    match($0, /^[[:space:]]*(typeset[[:space:]]+-g[[:space:]]+)?POWERLEVEL9K_CONTEXT_TEMPLATE=/) {
      print substr($0, 1, RLENGTH) "'\''" nickname "'\''"
      replaced=1
      next
    }
    { print }
    END { exit(replaced ? 0 : 1) }
  ' "$p10k_config" >"$temp_p10k_config"; then
    mv "$temp_p10k_config" "$p10k_config"
    p10k_state_set customized 1
    msg_success "Saved Powerlevel10k username/nickname."
  else
    rm -f "$temp_p10k_config"
    msg_error "Could not find an uncommented POWERLEVEL9K_CONTEXT_TEMPLATE= line in $p10k_config."
  fi
}

_p10k_seg_is_on() {
  local blk="$1" name="$2" file="$3"
  awk -v want="$blk" -v name="$name" '
    /POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=\(/  { blk="L"; next }
    /POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=\(/ { blk="R"; next }
    blk!="" && /^[[:space:]]*\)/            { blk=""; next }
    blk==want {
      if ($0 ~ ("^[[:space:]]*" name "([[:space:]]|$)"))              { state="1" }
      else if ($0 ~ ("^[[:space:]]*#[[:space:]]*" name "([[:space:]]|$)")) { state="0" }
    }
    END { print state }
  ' "$file"
}

_p10k_write_segments() {
  local file="$1" Los="$2" Lvcs="$3" Rnode="$4" Rtime="$5" Rpackage="$6" Rcontext="$7"
  local tmp
  tmp="$(mktemp)"
  awk -v Los="$Los" -v Lvcs="$Lvcs" -v Rnode="$Rnode" -v Rtime="$Rtime" -v Rpackage="$Rpackage" -v Rcontext="$Rcontext" '
    function apply(line, want,   indent, rest) {
      match(line, /^[[:space:]]*/); indent = substr(line, 1, RLENGTH); rest = substr(line, RLENGTH + 1)
      sub(/^#[[:space:]]*/, "", rest)
      if (want == 1) return indent rest
      return indent "#" rest
    }
    /POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=\(/  { blk = "L"; print; next }
    /POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=\(/ { blk = "R"; print; next }
    blk != "" && /^[[:space:]]*\)/          { blk = ""; print; next }
    blk == "L" && /^[[:space:]]*#?[[:space:]]*os_icon([[:space:]]|$)/      { print apply($0, Los);      next }
    blk == "L" && /^[[:space:]]*#?[[:space:]]*vcs([[:space:]]|$)/          { print apply($0, Lvcs);     next }
    blk == "R" && /^[[:space:]]*#?[[:space:]]*node_version([[:space:]]|$)/ { print apply($0, Rnode);    next }
    blk == "R" && /^[[:space:]]*#?[[:space:]]*time([[:space:]]|$)/         { print apply($0, Rtime);    next }
    blk == "R" && /^[[:space:]]*#?[[:space:]]*package([[:space:]]|$)/      { print apply($0, Rpackage); next }
    blk == "R" && /^[[:space:]]*#?[[:space:]]*context([[:space:]]|$)/      { print apply($0, Rcontext); next }
    { print }
  ' "$file" >"$tmp" && mv "$tmp" "$file"
}

_configure_p10k_segments() {
  local p10k_config="$HOME/.p10k.zsh"
  if [ ! -f "$p10k_config" ]; then
    cp "$ZSH_INSTALL"/resources/themes/.p10k.zsh "$p10k_config"
  fi

  local -a seg_block=(L L R R R R)
  local -a seg_name=(os_icon vcs node_version time package context)
  local -a seg_label=(os_icon vcs node_version time package user)
  local -a seg_state
  local n=${#seg_name[@]}

  local i st
  for ((i = 0; i < n; i++)); do
    st="$(_p10k_seg_is_on "${seg_block[$i]}" "${seg_name[$i]}" "$p10k_config")"
    [ "$st" = "1" ] && seg_state[$i]=1 || seg_state[$i]=0
  done

  local selected=0
  local save_index=$n
  local eol=$'\033[K'
  local key last_block cursor box

  _menu_hide_cursor
  _menu_reset_screen
  while true; do
    _menu_home
    msg_title "Change Powerlevel10k segments$eol"
    msg "$eol"
    msg_dimmed "Toggle segments on/off. Off means the line is commented (#) in ~/.p10k.zsh.$eol"
    msg "$eol"

    last_block=""
    for ((i = 0; i < n; i++)); do
      if [ "${seg_block[$i]}" != "$last_block" ]; then
        last_block="${seg_block[$i]}"
        [ "$i" -gt 0 ] && msg "$eol"
        if [ "$last_block" = "L" ]; then
          msg_title "LEFT segments$eol"
        else
          msg_title "RIGHT segments$eol"
        fi
      fi
      cursor="  "
      [ "$selected" -eq "$i" ] && cursor="➤ "
      if [ "${seg_state[$i]}" -eq 1 ]; then box="[x]"; else box="[ ]"; fi
      msg " $cursor$box ${seg_label[$i]}$eol"
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
        printf '%s' "Apply these changes to ~/.p10k.zsh? (y/N): " >&2
        local confirm
        IFS= read -rsn1 confirm
        printf '%s\n' "$confirm" >&2
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
          _p10k_write_segments "$p10k_config" \
            "${seg_state[0]}" "${seg_state[1]}" "${seg_state[2]}" "${seg_state[3]}" "${seg_state[4]}" "${seg_state[5]}"
          msg_success "Saved Powerlevel10k segments."
          p10k_state_set customized 1
          p10k_action_ran=1
        else
          msg_warning "No changes applied."
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

###########
# PROGRAM #
###########
repo_version=$(get_repo_version)

menu_title="Configure Powerlevel Wizard v$repo_version"
menu_header="How do you want to configure?"
menu_labels=(
  "Use full Powerlevel10k configuration wizard"
  "Use Axel Powerlevel10k configuration wizard preset (recommended)"
  "Change Powerlevel10k username/nickname"
  "Change Powerlevel10k segments"
)
menu_checks=()
menu_sections=(
  "Installation:"
  ""
  "Customization:"
  ""
)
menu_actions=(
  "_configure_p10k_wizard"
  "_configure_p10k_preset"
  "_configure_p10k_nickname"
  "_configure_p10k_segments"
)
menu_selected=0
case "$(p10k_state_get install)" in
full) menu_selected=0 ;;
axel) menu_selected=1 ;;
esac
menu_footer="Note: You can finetune all segments, colors and more at '~/.p10k.zsh'"
run_action_menu
clear

# Whatever the user did here (applied a preset, changed segments, or just
# quit), return control to the calling wizard so it lands back on the main
# menu instead of terminating. Prompt changes take effect on the next shell.
printf '\033[?25h' >&2
exit 90
