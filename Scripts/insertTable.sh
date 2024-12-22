#!/usr/bin/bash
insertIntoTable() {
    # Prompt user to enter the table name
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))
    # Dynamically present the file selection menu
    select item in "${list[@]}" "Cancel" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
        elif [[ "$item" == "Cancel" ]]; then
            echo "You selected: $item Backing to TableMenu"
            . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
            break
        elif [[ -n "$item" ]]; then
            echo "You selected: $item"
            tableName="${item}"
            break
        else
            echo "Invalid selection, try again."
        fi
    done

    # Check if the table exists
    while true; do
        if [[ -e "${PWD}/$tableName" && -f "${PWD}/$tableName" ]]; then
            echo "Proceeding with insertion into table '$tableName'."
            break
        else
            echo "Table '$tableName' doesn't exist. Please choose another name."
            read -r -p "Enter Table Name again: " tableName
        fi
    done
    echo -e "Using table: $tableName\n"
    # Read metadata file
    metadataFile="${PWD}/${tableName}.meta_data"
    if [[ ! -e "$metadataFile" ]]; then
        echo "Error: Metadata file not found for table '$tableName'."
        . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
        return 1
    fi
    # Read metadata lines into an array
    # IFS=$'\n' read -d '' -r -a lines < "$metadataFile"
    #  mapfile -t lines < /home/zalabany/DBMS-Bash-Project/DataBase/DB1/TB3.meta_data
    lines=($(awk '{print $0}' $metadataFile))
    numColumns="${#lines[@]}"
    tableContent=""
    # Process each column based on metadata
    echo "The First Value is Your PrimaryKey"
    for i in "${!lines[@]}"; do
        IFS=':' read -r colName colDataType colPK <<<"${lines[i]}"
        while true; do
            # Prompt user for column value
            read -r -p "Enter value for $colName ($colDataType): " ColValue
            valid=1

            # Validate data type
            if [[ $colDataType == "int" && ! $ColValue =~ ^[0-9]+$ ]]; then
                echo "ERROR: Value must be an integer."
                valid=0
            elif [[ $colDataType != "int" && ! $ColValue =~ ^[a-zA-Z_]+$ ]]; then
                echo "ERROR: Value must be a string."
                valid=0
            fi
            # Validate primary key
            if [[ $colPK == "PK" ]]; then
                while IFS= read -r record; do
                    IFS=':' read -r -a fields <<<"$record"
                    if [[ "${fields[0]}" == "$ColValue" ]]; then
                        echo "ERROR: Primary key must be unique."
                        valid=0
                        break
                    fi
                done <"${PWD}/${tableName}"
            fi
            [[ $valid -eq 1 ]] && break
        done
        if [[ $i -eq $((numColumns - 1)) ]]; then
            tableContent+="$ColValue"
        else
            tableContent+="$ColValue:"
        fi
    done
    echo "$tableContent" >>"${PWD}/${tableName}"
    echo "Data successfully inserted into table '$tableName'."
}

insertIntoTable
