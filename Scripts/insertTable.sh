#!/usr/bin/bash

insertIntoTable() {
    # Prompt user to enter the table name
    read -r -p "Enter Table Name: " Tname

    # Check if the table exists
    while true; do
        if [[ -e "${PWD}/$Tname" && -f "${PWD}/$Tname" ]]; then
            echo "Proceeding with insertion into table '$Tname'."
            break
        else
            echo "Table '$Tname' doesn't exist. Please choose another name."
            read -r -p "Enter Table Name again: " Tname
        fi
    done

    echo -e "Using table: $Tname\n"

    # Read metadata file
    metadataFile="${PWD}/${Tname}.meta_data"
    if [[ ! -e "$metadataFile" ]]; then
        echo "Error: Metadata file not found for table '$Tname'."
        return 1
    fi

    # Read metadata lines into an array
    IFS=$'\n' read -d '' -r -a lines < "$metadataFile"
    numColumns=${#lines[@]}
    tableContent=""

    # Process each column based on metadata
    for i in "${!lines[@]}"; do
        IFS=':' read -r colName colDataType colPK <<< "${lines[i]}"

        while true; do
            # Prompt user for column value
            read -r -p "Enter value for $colName ($colDataType): " ColValue
            valid=1

            # Validate data type
            if [[ $colDataType == "int" && ! $ColValue =~ ^[0-9]+$ ]]; then
                echo "ERROR: Value must be an integer."
                valid=0
            fi

            # Validate primary key
            if [[ $colPK == "PK" ]]; then
                while IFS= read -r record; do
                    IFS=':' read -r -a fields <<< "$record"
                    if [[ "${fields[0]}" == "$ColValue" ]]; then
                        echo "ERROR: Primary key must be unique."
                        valid=0
                        break
                    fi
                done < "${PWD}/${Tname}"
            fi

            # Break loop if input is valid
            [[ $valid -eq 1 ]] && break
        done

        # Add column value to the row content
        if [[ $i -eq $((numColumns - 1)) ]]; then
            tableContent+="$ColValue"
        else
            tableContent+="$ColValue:"
        fi
    done

    # Append the new row to the table file
    echo "$tableContent" >> "${PWD}/${Tname}"
    echo "Data successfully inserted into table '$Tname'."
}

insertIntoTable
