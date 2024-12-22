#!/usr/bin/bash
shopt -s extglob # Enable extended pattern matching

function deleteALL() {
    tableName="$1"
    colIndex="$2"
    currentValue="$3"
    echo "$1 $2 $3"

    if [[ -z "$tableName" || -z "$colIndex" ]]; then
        echo "Error: Table name and column index must not be empty."
        . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh
        return 1
    fi

    # Check if the table file exists
    if [[ ! -f "${PWD}/${tableName}" ]]; then
        echo "Error: Table '${tableName}' not found."
        . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh
        return 1
    fi

    # Delete all or delete specific rows based on column index and value
    if [[ -n "$currentValue" && -n "$colIndex" && "$colIndex" != "DeleteAll" ]]; then
        currentValueLocation=($(
            awk -v colIndex="${colIndex}" -v currentValue="${currentValue}" '
            BEGIN { FS=":"; OFS=":" }
            {
                if ($colIndex == currentValue) {
                    print $0;
                }
            }
            ' "${PWD}/${tableName}"
        ))
    elif [[ -n "$colIndex" && "$colIndex" == "DeleteAll" ]]; then
        currentValueLocation=($(awk 'BEGIN { FS=":"; OFS=":" }{print $0}' "${PWD}/${tableName}"))
    else
        echo "Invalid Option"
        . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh
    fi
    echo "${currentValueLocation[@]}"
    if [[ -n "${currentValueLocation}" ]]; then
        for lines in "${currentValueLocation[@]}"; do
            echo "Deleting: $lines"
            sed -i "/^$lines$/d" "${PWD}/${tableName}"
        done
        . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh

    else
        echo "No matching records found to delete."
        . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh

    fi
}

# Call the function with arguments (if any)
deleteALL "$1" "$2" "$3"
