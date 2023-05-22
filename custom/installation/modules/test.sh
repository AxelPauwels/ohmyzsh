#!/usr/bin/env bash

show_examples() {
  echo
  echo "============= EXAMPLES ============="

  echo
  echo "COLORS ----------------------------"
  printf "${txt_red}This is red text.${txt_reset}\n"
  printf "${txt_green}This is green text.${txt_reset}\n"
  printf "${txt_yellow}This is yellow text.${txt_reset}\n"
  printf "${txt_blue}This is blue text.${txt_reset}\n"
  printf "${txt_magenta}This is magenta text.${txt_reset}\n"
  printf "${txt_cyan}This is cyan text.${txt_reset}\n"
  printf "${txt_white}This is white text.${txt_reset}\n"
  printf "${txt_bold}This is bold text.${txt_reset}\n"
  printf "${txt_dimmed}This is dimmed text.${txt_reset}\n"
  printf "${txt_italic}This is italic text.${txt_reset}\n"
  printf "${txt_underline}This is underlined text.${txt_reset}\n"
  printf "${txt_blink_slow}This is blinking slow text.${txt_reset}\n"
  printf "${txt_blink_rapid}This is blinking rapid text.${txt_reset}\n"
  printf "${txt_reverse}This is text with reversed colors.${txt_reset}\n"
  printf "${txt_hidden}This is hidden text.${txt_reset}\n"
  printf "${txt_strikethrough}This is strikethrough text.${txt_reset}\n"

  echo
  echo "ICONS -----------------------------"
  printf "${icon_check} (check)"
  echo
  printf "${icon_times} (times)"
  echo
  printf "${icon_exclamation} (exclamation)"
  echo

  echo
  echo "FUNCTIONS -------------------------"
  msg_inline "msg_inline "
  msg "(a 2nd message on same line)"
  msg "msg"
  msg_title "msg_title"
  msg_italic "msg_italic"
  msg_dimmed "msg_dimmed"
  msg_url "http://msg_url"
  msg_searching "msg_searching"
  msg_found "msg_found"
  msg_not_found "msg_not_found"
  msg_installed "msg_installed"
  msg_success "msg_success"
  msg_warning "msg warning"
  msg_error "msg_error"
  msg_installed_no_icon "msg_installed_no_icon"
  msg_error_no_icon "msg_error_no_icon"
  msg_warning_no_icon "msg_warning_no_icon"

  echo
  echo "==================================="
}
