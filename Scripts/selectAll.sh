#!/usr/bin/bash
shopt -s extglob # Enable extended pattern matching
clear
function selectAll() {
    tableName="$1" # Example: Table name (file)
    colIndex="$2"  # Example: Column index
    oldValue="$3"  # Example: Value to find
    echo "$tableName" $colIndex
    # Ensure tableName and colIndex are not empty
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

    # Output the result
    OFS="\t" echo -e "$oldValueLocation"
}

# Call the function with arguments (if any)
selectAll "$1" "$2" "$3" "$4"
