#! /usr/bin/bash
shopt -s extglob # Enable extended pattern matching
function selectAll() {

    tableName=$1
    PK=$2
    oldValue=$3 ind
    if [[ -z "$tableName" || -z "$colIndex" ]]; then
        echo "Error: Table name and column index must not be empty."
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
        return 1
    fi
    if [[ ! -f "${PWD}/${tableName}" ]]; then
        echo "Error: Table '${tableName}' not found."
        . ~/DBMS-Bash-Project/Scripts/selectMen
    fi
    if [[ -z "$oldValue" || -z "$tableName" || -z "$colIndex" ]]; then
        echo "The Value must not be empty."
        . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
    fi
    oldValueLocation=$(
        awk -v colIndex="${PK}" -v oldValue="${oldValue}" '
    BEGIN { FS = ":"; OFS = ":" }
    {
       {
        if ($1 == PK) {  
        for (i = 1; i <= NF; i++) {
            if ($i == oldValue) { 
                $i = newValue 
                print $0  # Print the updated line
              
            }
        }
    }
    
    }' "${PWD}/${tableName}"

    )
    echo "$oldValueLocation"

}

selectAll $1 $2 $3 $4
