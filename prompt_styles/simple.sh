#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   06.06.2018

fancygit_prompt_builder() {
    . ~/.fancy-git/prompt_styles/base-simple.sh
    . ~/.fancy-git/modules/update-manager.sh

    check_for_update

    local user
    local at
    local host
    local where
    local venv=""
    local user_at_host=""
    local ps1

    user="${fancygit_bold}${fancygit_color_light_green}\u${fancygit_color_reset}"
    at="${fancygit_color_reset}@${fancygit_color_reset}"
    host="${fancygit_color_light_green}\h${fancygit_color_reset}"
    where="${fancygit_color_blue}${fancygit_prompt_path}${fancygit_color_reset}${fancygit_bold_reset}"

    user_at_host="$user$at$host:"

    if ! [ -z ${VIRTUAL_ENV} ]; then
        venv="(`basename \"$VIRTUAL_ENV\"`) "
    fi

    prompt_user=$(fancygit_setting_show_hide "show-user-at-machine" "$user_at_host" "$user_at_host_start" "$user_at_host_end")
    PS1="${fancygit_bold}${venv}${prompt_user}$where\$${fancygit_bold_none} "

    if ! [ -z "$fancygit_git_branch_name" ]; then
        PS1="${fancygit_bold}${venv}${prompt_user}$where\$${fancygit_bold}${fancygit_repo_status_section}${fancygit_bold_reset}(${fancygit_git_branch_icon}${fancygit_color_orange}${fancygit_git_branch_name}${fancygit_color_reset})${fancygit_bold_reset} "
    fi
}

PROMPT_COMMAND="fancygit_prompt_builder"
