#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   03.02.2016
#
# Commands manager.

. ~/.fancy-git/modules/settings-manager.sh
. ~/.fancy-git/modules/update-manager.sh
. ~/.fancy-git/version.sh

fancygit_script_help() {
    sh ~/.fancy-git/help.sh | less
}

fancygit_show_version() {
    local current_year
    current_year=$(date +%Y)
    echo " Fancy Git v$FANCYGIT_VERSION - $current_year by Diogo Alexsander Cavilha <diogocavilha@gmail.com>."
    echo ""
}

fancygit_command_not_found() {
    echo ""
    echo " $1: Command not found."
    fancygit_script_help
}

fancygit_install_fonts() {
    mkdir -p ~/.fonts
    cp -i ~/.fancy-git/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf ~/.fonts
    cp -i ~/.fancy-git/fonts/Sauce-Code-Pro-Nerd-Font-Complete-Windows-Compatible.ttf ~/.fonts
    fc-cache -fv
}

fancygit_show_colors_config() {
    echo "
git config --global color.ui true

git config --global color.diff.meta \"yellow bold\"
git config --global color.diff.old \"red bold\"
git config --global color.diff.new \"green bold\"
git config --global color.status.added \"green bold\"
git config --global color.status.changed \"yellow\"
git config --global color.status.untracked \"cyan\"
"
}

fancygit_colors_config_set() {
    `git config --global color.ui true`
    `git config --global color.diff.meta "yellow bold"`
    `git config --global color.diff.old "red bold"`
    `git config --global color.diff.new "green bold"`
    `git config --global color.status.added "green bold"`
    `git config --global color.status.changed "yellow"`
    `git config --global color.status.untracked "cyan"`
}

fancygit_return() {
    local fg_os
    fg_os=$(uname)

    if [ "$fg_os" = "Linux" ]; then
        return
    fi
}

case "$1" in
    "-h"|"--help") fancygit_script_help;;
    "-v"|"--version") fancygit_show_version;;
    "--colors") fancygit_show_colors_config;;
    "--colors-set") fancygit_colors_config_set;;
    "--enable-full-path") fancygit_settings_set "show-full-path" "true";;
    "--disable-full-path") fancygit_settings_set "show-full-path" "false";;
    "--enable-show-user-at-machine") fancygit_settings_set "show-user-at-machine" "true";;
    "--disable-show-user-at-machine") fancygit_settings_set "show-user-at-machine" "false";;
    "--config-list") fancygit_settings_show;;
    "--config-reset") fancygit_settings_reset;;
    "update") fancygit_update;;
    "simple") fancygit_settings_set "style" "simple";;
    "default") fancygit_settings_set "style" "default";;
    "double-line") fancygit_settings_set "style" "fancy-double-line";;
    "simple-double-line") fancygit_settings_set "style" "simple-double-line";;
    "human") fancygit_settings_set "style" "human";;
    "human-single-line") fancygit_settings_set "style" "human-single-line";;
    "human-dark") fancygit_settings_set "style" "human-dark";;
    "human-dark-single-line") fancygit_settings_set "style" "human-dark-single-line";;
    "dark") fancygit_settings_set "style" "dark";;
    "dark-double-line") fancygit_settings_set "style" "dark-double-line";;
    "dark-col-double-line") fancygit_settings_set "style" "dark-col-double-line";;
    "light") fancygit_settings_set "style" "light";;
    "light-double-line") fancygit_settings_set "style" "light-double-line";;
    "configure-fonts") fancygit_install_fonts;;
    "") fancygit_return;;
    *) fancygit_command_not_found "$1";;
esac
