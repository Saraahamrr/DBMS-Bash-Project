#!/usr/bin/bash
shopt -s extglob # Enable extended pattern matching
clear
function selectAll() {
    tableName="$1"
    colIndex="$2"
    oldValue="$3"
    echo "$tableName" $colIndex

    if [[ -z "$tableName" || -z "$colIndex" ]]; then
        echo "Error: Table name and column index must not be empty."
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
        return 1
    fi
    if [[ ! -f "${PWD}/${tableName}" ]]; then
        echo "Error: Table '${tableName}' not found."
        return 1
    fi

    if [[ -n "$oldValue" ]]; then
        oldValueLocation=$(
            awk -v colIndex="${colIndex}" -v oldValue="${oldValue}" '
            BEGIN { FS=":"; OFS="\n" }
            {
                if ($colIndex == oldValue) {
                    print $colIndex;
                }
            }
            ' "${PWD}/${tableName}"
        )
    elif [[ -z "$oldValue" ]]; then
        oldValueLocation=$(
            awk -v colIndex="${colIndex}" '
            BEGIN { FS=":"; OFS="\n" }
            {
                print $colIndex;
            }
            ' "${PWD}/${tableName}"
        )
    elif [[ "$colIndex" == "All" ]]; then
        oldValueLocation=$(
            awk '
            BEGIN { FS=":"; OFS="/n" }
            {
                print $0;
            }
            ' "${PWD}/${tableName}"
        )
    else
        echo "Invalid Option"
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
        return 1
    fi

    OFS="\t" echo -e "$oldValueLocation"
}

selectAll "$1" "$2" "$3" "$4"
