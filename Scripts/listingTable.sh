#! /usr/bin/env bash
shopt -s extglob
function listTable() {

    lists=($(ls "${PWD}" | grep -v '\.meta_data$'))
    for list in "${lists[@]}"; do
        echo "${list}"
    done
    . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
}
listTable
