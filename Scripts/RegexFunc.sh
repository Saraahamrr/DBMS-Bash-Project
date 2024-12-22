#! /usr/bin/env bash
shopt -s extglob

function check_dbname() {
    local dbname="$1" # Local variable to hold the database name

    # Ensure no leading or trailing spaces, and only valid characters (letters, numbers, underscores)
    if [[ "$dbname" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo "Valid database name."
        return 0
    else
        return 1
    fi
    echo "${dbname}"
}
