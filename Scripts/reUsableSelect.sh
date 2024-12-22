#!/bin/bash
shopt -s extglob
clear
function reUsableSelect() {
    tableName="$1"
    colIndex="selectAll"
    if [[ -z "$tableName" || -z "$colIndex" ]]; then
        echo "Error: Table name and column index must not be empty."
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
        return 1
    fi
    if [[ ! -f "${PWD}/${tableName}" ]]; then
        echo "Error: Table '${tableName}' not found."
        return 1
    fi

    if [[ "$colIndex" == "selectAll" ]]; then
        currentValueLocation=$(
            awk '
            BEGIN { FS=":"; OFS="\n" }
            {
                print $0;
            }
            ' "${PWD}/${tableName}"
        )
    else
        echo "Invalid Option"
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
    fi

    echo "$currentValueLocation"
}

reUsableSelect "$1" "$2" "$3" "$4"
