# File: ~/.oh-my-zsh/custom/custom_examples/example-colors-and-formats.zsh
# ------------------------------------------------------------------------



##################################
# EXAMPLE: COLORS AND FORMATTING #
##################################

echo "**********"
echo "FORMATTING"
echo "**********"
echo -e "This is normal text"
echo -e "This is ${FORMAT_BOLD}bold${FORMAT_RESET} text. (Note: FORMAT_BOLD_RESET doesn't work)"
echo -e "This is ${FORMAT_DIM}dim${FORMAT_DIM_RESET} text."
echo -e "This is ${FORMAT_UNDERLINED}underlined${FORMAT_UNDERLINED_RESET} text."
echo -e "This is ${FORMAT_REVERSED}reversed${FORMAT_REVERSED_RESET} text."
echo -e "This is ${FORMAT_STRIKED}striked${FORMAT_STRIKED_RESET} text."
echo ""
echo -e "${COLOR_GREEN}${FORMAT_BOLD}${FORMAT_UNDERLINED}This is green, bold, underlined${FORMAT_RESET}"
echo -e "${BGCOLOR_GREEN}${COLOR_RED}This is bgcolor green and color red${FORMAT_RESET}"
echo -e "${COLOR_GREEN}color green, ${FORMAT_REVERSED} reversed ${FORMAT_REVERSED_RESET}, undo reversed, ${FORMAT_RESET} no format"
echo ""

echo "***************"
echo "COLOR VARIABLES"
echo "***************"
echo -e "${COLOR_BLACK}color_black${COLOR_RESET}"
echo -e "${COLOR_GRAY75}color_gray75${COLOR_RESET}"
echo -e "${COLOR_GRAY50}color_gray50${COLOR_RESET}"
echo -e "${COLOR_GRAY25}color_gray25${COLOR_RESET}"
echo -e "${COLOR_WHITE}color_white${COLOR_RESET}"
echo -e "${COLOR_RED}color_red${COLOR_RESET}"
echo -e "${COLOR_GREEN}color_green${COLOR_RESET}"
echo -e "${COLOR_BLUE}color_blue${COLOR_RESET}"
echo -e "${COLOR_ORANGE}color_orange${COLOR_RESET}"
echo -e "${COLOR_PINK}color_pink${COLOR_RESET}"
echo -e "${COLOR_PURPLE}color_purple${COLOR_RESET}"
echo -e "${COLOR_YELLOW}color_yellow${COLOR_RESET}"
echo ""

echo "*********"
echo "FUNCTIONS"
echo "*********"
echo "$(_messageSuccess "This is messageSuccess")"
echo "$(_messageWarning "This is messageWarning")"
echo "$(_messageError "This is messageError")"
echo "$(_messageInfo "This is messageInfo")"
echo "$(_messageCommand "This is messageCommand")"
echo "$(_messageCommandInfo "This is messageCommandInfo")"
echo "$(_messageFinish "This is messageFinish")"
echo ""
echo "$(_textColor black "This is textColor black")"
echo "$(_textColor gray75 "This is textColor gray75")"
echo "$(_textColor gray50 "This is textColor gray50")"
echo "$(_textColor gray25 "This is textColor gray25")"
echo "$(_textColor white "This is textColor white")"
echo "$(_textColor red "This is textColor red")"
echo "$(_textColor green "This is textColor green")"
echo "$(_textColor blue "This is textColor blue")"
echo "$(_textColor orange "This is textColor orange")"
echo "$(_textColor pink "This is textColor pink")"
echo "$(_textColor purple "This is textColor purple")"
echo "$(_textColor yellow "This is textColor yellow")"
echo ""