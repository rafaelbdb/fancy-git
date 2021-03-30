#!/bin/bash
#
# Author: Rafael Borges Dias Baptista <r.borjovsky@gmail.com>
# Date:   30.03.2021
#
# git pull --all

. ~/.fancy-git/random_messages.sh

run() {
    git pull --all

    _fancygit_after_pulling_random_message
}
