# File: ~/.oh-my-zsh/custom/3G-grunt.zsh
# --------------------------------------



# todo
#echo "TODO: codesnifferPath()"
# todo

#function to add path in a project in file src/vendor/squizlabs/php_codesniffer/CodeSniffer.conf
#todo  add parameter
addCodesnifferPath()
{
  php src/vendor/bin/phpcs --config-set installed_paths /Users/axelpauwels/Documents/projects/"$1"-mage2-webshop/src/vendor/magento/marketpla$
}



# End-of-file ----------------------------------
#echo "${COLOR_GREEN}${EMOJI_CHECK}${COLOR_GRAY25} Grunt${COLOR_RESET}"
