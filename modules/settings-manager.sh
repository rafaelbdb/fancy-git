#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   09.20.2020
#
# Settings manager.

FANCYGIT_APP_SETTINGS_FILE_SAMPLE=~/.fancy-git/app_config_sample
FANCYGIT_APP_SETTINGS_FILE=~/.fancy-git/app_config

fancygit_settings_show() {
    cat "$FANCYGIT_APP_SETTINGS_FILE"
}

fancygit_settings_reset() {
    rm -f "$FANCYGIT_APP_SETTINGS_FILE"
    cp "$FANCYGIT_APP_SETTINGS_FILE_SAMPLE" "$FANCYGIT_APP_SETTINGS_FILE"
    sed -i '/fresh_file/d' "$FANCYGIT_APP_SETTINGS_FILE"
}

fancygit_settings_set() {
    __fancygit_settings_create_if_not_exists "$1"
    sed -i "s/^${1}:.*/${1}:${2}/" "$FANCYGIT_APP_SETTINGS_FILE"
}

__fancygit_settings_create_if_not_exists() {
    local setting=""

    setting=$(grep -o "${1}:" < "$FANCYGIT_APP_SETTINGS_FILE")

    if [ -z "$setting" ]; then
        echo "${1}false" >> "$FANCYGIT_APP_SETTINGS_FILE"
    fi
}

fancygit_setting_get() {
    local enabled=""

    enabled=$(grep -oP "(?<=${1}:).*" < "$FANCYGIT_APP_SETTINGS_FILE")

    echo "$enabled"
}
