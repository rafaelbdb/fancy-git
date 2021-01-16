#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   06.11.2018

fancygit_prompt_builder() {
    . ~/.fancy-git/prompt_styles/base-simple.sh
    . ~/.fancy-git/modules/update-manager.sh

    check_for_update

    # Colors
    local light_magenta="\\[\\e[95m\\]"
    local branch_name=""

    # Prompt
    local user="${fancygit_color_orange}\u${fancygit_color_reset}"
    local host="${fancygit_color_light_yellow}\h${fancygit_color_reset}"
    local where="${fancygit_color_light_green}${fancygit_prompt_path}${fancygit_color_reset}"
    local venv=""
    local user_at_host="${user} at ${host} in "

    if ! [ -z ${VIRTUAL_ENV} ]; then
        venv="${fancygit_color_light_yellow}`basename \"$VIRTUAL_ENV\"`${fancygit_color_reset} for "
    fi


    if [ "$fancygit_git_branch_name" != "" ]; then
        branch_name="on ${light_magenta}${fancygit_git_branch_name}${fancygit_color_reset}"
    fi

    prompt_user=$(fancygit_setting_show_hide "show-user-at-machine" "$user_at_host" "$user_at_host_start" "$user_at_host_end")

    PS1="${fancygit_bold}${venv}${prompt_user}$where $branch_name${fancygit_repo_status_section} ${fancygit_bold_reset}\n\$ "
}

PROMPT_COMMAND="fancygit_prompt_builder"

