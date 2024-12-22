#! /usr/bin/bash
shopt -s extglob # Enable extended pattern matching
clear
function updateRecord() {
    # Initialize variables
    PK=$1 # Value to find
    oldValue=$2
    newValue=$3  # Value to replace with
    tableName=$4 # Table name (file)
    if [[ -z "$oldValue" || -z "$newValue" || -z "$tableName" || -z "$PK" ]]; then
        echo "The Value must not be empty."
        . ~/DBMS-Bash-Project/Scripts/updateMenu.sh
    fi

    # Use awk to find and modify the column value
    newValueLocation=$(
        awk -v PK="${PK}" -v oldValue="${oldValue}" -v newValue="${newValue}" '
    BEGIN { FS = ":"; OFS = ":" }
    {
        if ($1 == PK) {  # Check if the primary key matches
        for (i = 1; i <= NF; i++) {
            if ($i == oldValue) {  # Check if the field matches oldValue
                $i = newValue  # Replace with newValue
                print $0  # Print the updated line
              
            }
        }
    }
    
    }' "${PWD}/${tableName}"
    )
    oldValueLocation=$(
        awk -v PK="${PK}" -v oldValue="${oldValue}" -v newValue="${newValue}" '
    BEGIN { FS = ":"; OFS = ":" }
    {
        if ($1 == PK) {  # Check if the primary key matches
        for (i = 1; i <= NF; i++) {
            if ($i == oldValue) {  # Check if the field matches oldValue
                print $0  # Print the updated line
            }
        }
    }
    
    }' "${PWD}/${tableName}"
    )
    # Read data into arrays
    IFS=":" read -r -a validateData <<<"${newValueLocation}"
    meta_data=($(awk -F: '{print $2}' "${PWD}/${tableName}.meta_data"))
    IFS=" " read -r -a metaType <<<"${meta_data[@]}"

    echo "validateData: ${validateData[@]}"
    echo "metaType: ${metaType[@]}"

    valid=1
    for j in "${!validateData[@]}"; do
        if [[ "${metaType[$j]}" == "int" ]]; then
            if [[ ! "${validateData[$j]}" =~ ^[0-9]+$ ]]; then
                echo "${validateData[$j]} ===> ${metaType[$j]}"
                echo "ERROR: Value must be an integer."
                valid=0
                break
            fi
        else
            if [[ ! "${validateData[$j]}" =~ ^[a-zA-Z_]+$ ]]; then
                echo "ERROR: Value must be a string (letters and underscores only)."
                echo "${validateData[$j]} ===> ${metaType[$j]}"
                valid=0
                break
            fi
        fi
    done

    if [[ $valid -eq 1 ]]; then
        if [[ -n "$oldValueLocation" ]]; then
            newValue=${newValueLocation}
            oldValue=$oldValueLocation
            # Update the file with sed, ensuring proper escaping for special characters
            sed -i "s/${oldValueLocation}/${newValueLocation}/g" "${PWD}/${tableName}"
            echo "File updated successfully."
        else
            echo -e "Not Found \nMight Be invalid Data"
        fi
    fi
}
updateRecord $1 $2 $3 $4
