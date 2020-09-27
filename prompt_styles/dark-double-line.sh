#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   12.02.2018

fancygit_prompt_builder() {
    . ~/.fancy-git/prompt_styles/base.sh
    . ~/.fancy-git/modules/update-manager.sh

    check_for_update

    local prompt_user
    local prompt_symbol
    local prompt_symbol_double_line

    # Main colors and backgrounds of the theme
    local dark_gray
    local dark_gray_01
    local bg_dark_gray
    local bg_dark_gray_01
    
    # separators
    local icon_separator_darkgray_bgdarkgray01
    local icon_separator_darkgray01_bgdarkgray
    local icon_separator_darkgray01_bgwhite
    local icon_separator_darkgray01_bglightyellow
    local icon_separator_darkgray01_bglightgreen
    local icon_separator_darkgray01
    
    # Prompt style tags
    local user_at_host_start
    local user_at_host_end
    local user_symbol_start
    local user_symbol_end
    local path_start
    local path_git_start
    local path_end
    local branch_start
    local branch_end

    # Main colors and backgrounds of the theme
    dark_gray="\\[\\e[90m\\]"
    dark_gray_01="\\[\\e[38;5;234m\\]"
    bg_dark_gray="\\[\\e[100m\\]"
    bg_dark_gray_01="\\[\\e[48;5;234m\\]"
    
    # separators
    icon_separator_darkgray_bgdarkgray01="${dark_gray}${bg_dark_gray_01}${fancygit_icon_separator}${fancygit_bg_color_reset}${fancygit_color_reset}"
    icon_separator_darkgray01_bgdarkgray="${dark_gray_01}${bg_dark_gray}${fancygit_icon_separator}${fancygit_bg_color_reset}${fancygit_color_reset}"
    icon_separator_darkgray01_bgwhite="${dark_gray_01}${fancygit_bg_color_white}${fancygit_icon_separator}${fancygit_bg_color_reset}${fancygit_color_reset}${fancygit_bg_color_reset}"
    icon_separator_darkgray01_bglightyellow="${dark_gray_01}${fancygit_bg_color_light_yellow}${fancygit_icon_separator}${fancygit_bg_color_reset}${fancygit_color_reset}${fancygit_bg_color_reset}"
    icon_separator_darkgray01_bglightgreen="${dark_gray_01}${fancygit_bg_color_light_green}${fancygit_icon_separator}${fancygit_bg_color_reset}${fancygit_color_reset}${fancygit_bg_color_reset}"
    icon_separator_darkgray01="${dark_gray_01}${fancygit_icon_separator}${fancygit_color_reset}"
    
    # Prompt style tags
    user_at_host_start="${fancygit_color_white}${bg_dark_gray_01}${fancygit_bold}"
    user_at_host_end="${fancygit_bold_reset}${fancygit_bg_color_reset}${icon_separator_darkgray01_bgdarkgray}"
    user_symbol_start="${bg_dark_gray}${fancygit_bold}${fancygit_color_white}"
    user_symbol_end="${fancygit_color_reset}${fancygit_bold_reset}${fancygit_bg_color_reset}${icon_separator_darkgray_bgdarkgray01}"
    path_start="${bg_dark_gray_01}${fancygit_color_white}${fancygit_bold}"
    path_end="${fancygit_color_reset}${fancygit_bold_reset}"
    path_git_start="${bg_dark_gray_01}${fancygit_color_white}  ${fancygit_icon_git_repo} ${fancygit_bold}"
    
    branch_start="${icon_separator_darkgray01_bgwhite}${fancygit_bg_color_white}${fancygit_color_black}${fancygit_bold}"
    branch_end="${fancygit_bg_color_reset}${fancygit_color_reset}${fancygit_bold_reset}${fancygit_icon_separator_white}"

    prompt_user=$(fancygit_setting_show_hide "show-user-at-machine" "\\u@\\h" "$user_at_host_start" "$user_at_host_end")
    prompt_symbol="${user_symbol_start} \$ ${user_symbol_end}"

    prompt_symbol_double_line="\n${fancygit_color_light_green}${fancygit_icon_double_line}${fancygit_color_reset}"

    # Set branch background to yellow in case there are changes
    if ! [ -z "$fancygit_git_branch_status" ]; then
        branch_start="${icon_separator_darkgray01_bglightyellow}${fancygit_bg_color_light_yellow}${fancygit_color_black}${fancygit_bold}"
        branch_end="${fancygit_bg_color_reset}${fancygit_bold_reset}${fancygit_icon_separator_lightyellow}"
    fi

    # Set branch background to green in case there are staged files
    if ! [ -z "$fancygit_git_staged_files" ]; then
        branch_start="${icon_separator_darkgray01_bglightgreen}${fancygit_bg_color_light_green}${fancygit_color_black}${fancygit_bold}"
        branch_end="${fancygit_bg_color_reset}${fancygit_bold_reset}${fancygit_icon_separator_green}"
    fi

    prompt_path="${path_start}${fancygit_icon_virtualvenv} $fancygit_prompt_path ${path_end}${icon_separator_darkgray01}"

    PS1="${prompt_user}${prompt_symbol}${prompt_path}${prompt_symbol_double_line} "
    PS2="${fancygit_color_light_green}${fancygit_icon_PS2}${fancygit_color_reset} "

    if ! [ -z "$fancygit_git_branch_name" ]; then
        prompt_path="${path_git_start}${fancygit_repo_status_section} $fancygit_prompt_path ${path_end}"
        prompt_branch="${branch_start} ${fancygit_icon_branch} ${fancygit_git_branch_name} ${branch_end}"
        PS1="${prompt_user}${prompt_symbol}${prompt_path}${prompt_branch}${prompt_symbol_double_line} "
        return
    fi
}

PROMPT_COMMAND="fancygit_prompt_builder"
