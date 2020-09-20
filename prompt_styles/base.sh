#!/bin/bash

. ~/.fancy-git/modules/settings-manager.sh

# git commands output storing
fancygit_git_remote_name=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null | cut -d"/" -f1)
fancygit_git_remote_name=${fancygit_git_remote_name:-origin}
fancygit_git_branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
fancygit_git_branch_status=$(git status -s 2> /dev/null)
fancygit_git_staged_files=$(git diff --name-only --cached 2> /dev/null)
fancygit_git_stash=$(git stash list 2> /dev/null)
fancygit_git_untracked_files=$(git ls-files --others --exclude-standard 2> /dev/null)
fancygit_git_changed_files=$(git ls-files -m 2> /dev/null)
fancygit_git_number_unpushed_commits=$(git log --pretty=oneline $fancygit_git_remote_name/$fancygit_git_branch_name..HEAD 2> /dev/null | wc -l)
fancygit_git_unpushed_commits=$(git log $fancygit_git_remote_name/$fancygit_git_branch_name..HEAD 2> /dev/null)
fancygit_git_number_untracked_files=$(git ls-files --others --exclude-standard 2> /dev/null | wc -w)
fancygit_git_number_changed_files=$(git ls-files -m 2> /dev/null | wc -l)
fancygit_git_merged_branch=""

if [ "$fancygit_git_branch_name" != "master" ]; then
    fancygit_git_merged_branch=$(git branch -r --merged master 2> /dev/null | grep ${fancygit_git_branch_name} 2> /dev/null)
fi

# Icons
fancygit_icon_separator=""
fancygit_icon_git_repo=""
fancygit_icon_branch=""
fancygit_icon_local_branch=""
fancygit_icon_merged_branch=""
fancygit_icon_untracked_files="  "
fancygit_icon_changed_files="  "
fancygit_icon_added_files="  "
fancygit_icon_stash=" "
fancygit_icon_push="  "
fancygit_icon_virtualvenv=" "

# Colors / background colors
fancygit_bold="\\[\\e[1m\\]"
fancygit_bold_reset="\\[\\e[0m\\]"
fancygit_color_black="\\[\\e[30m\\]"
fancygit_color_white="\\[\\e[97m\\]"
fancygit_color_light_green="\\[\\e[92m\\]"
fancygit_color_light_yellow="\\[\\e[93m\\]"
fancygit_color_reset="\\[\\e[39m\\]"
fancygit_bg_color_white="\\[\\e[107m\\]"
fancygit_bg_color_light_green="\\[\\e[102m\\]"
fancygit_bg_color_light_yellow="\\[\\e[103m\\]"
fancygit_bg_color_reset="\\[\\e[49m\\]"

# Separator styles
fancygit_icon_separator_white="${fancygit_color_white}${fancygit_icon_separator}${fancygit_color_reset}"
fancygit_icon_separator_green="${fancygit_color_light_green}${fancygit_icon_separator}${fancygit_color_reset}"
fancygit_icon_separator_lightyellow="${fancygit_color_light_yellow}${fancygit_icon_separator}${fancygit_color_reset}"

# Start - fancygit repo status icons
if [ -z "$fancygit_git_changed_files" ]; then
    fancygit_icon_changed_files=""
fi

if [ -z "$fancygit_git_stash" ]; then
    fancygit_icon_stash=""
fi

if [ -z "$fancygit_git_untracked_files" ]; then
    fancygit_icon_untracked_files=""
fi

if [ -z "$fancygit_git_staged_files" ]; then
    fancygit_icon_added_files=""
fi

fancygit_icon_push="$fancygit_icon_push+$fancygit_git_number_unpushed_commits"
if [ -z "$fancygit_git_unpushed_commits" ]; then
    fancygit_icon_push=""
fi

if [ -z ${VIRTUAL_ENV} ]; then
    fancygit_icon_virtualvenv=""
fi

fancygit_prompt_path="\\W"
if [ "$(fancygit_setting_get 'show-full-path')" = "true" ]; then
    fancygit_prompt_path="\\w"
fi

fancygit_repo_status_section="\
${fancygit_icon_virtualvenv}\
${fancygit_icon_stash}\
${fancygit_icon_untracked_files}\
${fancygit_icon_changed_files}\
${fancygit_icon_added_files}\
${fancygit_icon_push}\
"
# End - fancygit repo status icons

function __fancygit_is_only_local_branch() {
    local only_local_branch=$(git branch -r 2> /dev/null | grep "${fancygit_git_branch_name}" | wc -l)

    if [ "$only_local_branch" == 0 ]; then
        return 0
    fi

    return 1
}

function fancygit_get_branch_icon() {
    if __fancygit_is_only_local_branch; then
        echo "$fancygit_icon_local_branch"
        return
    fi

    if ! [ -z "$fancygit_git_merged_branch" ]; then
        echo "$fancygit_icon_merged_branch"
        return
    fi

    echo "$fancygit_icon_branch"
}

fancygit_icon_branch=$(fancygit_get_branch_icon)

# It decides if we can show it or not, depending on the setting.
# $1: Setting name to check.
# $2: The way we want it to be shown, if so.
# $3: Open style tag
# $4: Close style tag
fancygit_setting_show_hide() {
    local setting_name="$1"
    local user_at_host="$2"
    local tag_open="$3"
    local tag_close="$4"

    if [ "$(fancygit_setting_get $setting_name)" = "true" ]; then
        echo "${tag_open}${user_at_host} ${tag_close}"
        return
    fi

    echo ""
}

function fg_branch_status() {
    local info=""

    if ! [ -z "$fancygit_git_stash" ]; then
        info="${info}∿${none} "
    fi

    if [ "$fancygit_git_number_untracked_files" -gt 0 ]; then
        info="${info}${cyan}?${none} "
    fi

    if [ "$fancygit_git_number_changed_files" -gt 0 ]; then
        info="${info}${light_green}+${none}${light_red}-${none} "
    fi

    if ! [ -z "$fancygit_git_staged_files" ]; then
        info="${info}${light_green}✔${none} "
    fi

    if [ "$fancygit_git_unpushed_commits" ]; then
        info="${info}${light_green}^${git_number_unpushed_commits}${none} "
    fi

    if ! [ -z "$fancygit_git_branch_name" ] && __fancygit_is_only_local_branch; then
        info="${info}${light_green}*${none} "
    fi

    if ! [ -z "$fancygit_git_merged_branch" ]; then
        info="${info}${light_green}<${none} "
    fi

    if ! [ -z "$info" ]; then
        info=$(echo "$info" | sed -e 's/[[:space:]]*$//')
        if [ "$1" == 1 ]; then
            echo " [$info]"
            return
        fi

        echo " $info"
        return
    fi

    echo ""
}
