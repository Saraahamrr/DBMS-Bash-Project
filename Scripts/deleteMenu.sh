#! /bin/bash
shopt -s extglob # Enable extended pattern matching

function DeleteMenu() {

    # List files in the current directory, excluding `.meta_data` files
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

    tableValue=($(~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$tableName"))

    # Construct the metadata file path
    metadataFile="${PWD}/${tableName}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $tableName. Exiting."
        exit 1
    fi

    # Read column names from the metadata file
    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    echo -e "Columns available: ${columnName[@]}"
    # Main column selection menu
    echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table*"
    select colName in "${columnName[@]}" "DeleteAll" "Exit"; do
        if [[ "$colName" == "Exit" ]]; then
            echo "Exiting Selecting process."
            break
        elif [[ -n "$colName" && "$colName" != "DeleteAll" ]]; then

            # Find the index of the selected column
            for i in "${!columnName[@]}"; do
                if [[ "${columnName[$i]}" == "$colName" ]]; then
                    colIndex=$((i + 1)) # Make it 1-based index for awk
                    break
                fi
            done
            echo "You selected: $colName (Index: $colIndex)"

            # Check if it's the primary key column (assume first column is PK)
            echo "${tableValue[@]}"
            if [[ "$colName" == "${columnName[0]}" ]]; then
                echo "You are attempting to delete the Primary Key (PK) column. If you leave the value empty, it will return the whole column."
                read -r -p "Enter the Primary Key value: " currentValue
                if [[ -f ~/DBMS-Bash-Project/Scripts/deleteAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/deleteAll.sh "$tableName" "$colIndex" "$currentValue"
                else
                    echo "deleteAll.sh script not found!"
                fi
            else
                echo -e "\nListing Columns\nIf you choose a column, you will delete in that column."
                echo "${tableValue[@]}"
                echo "You are selecting the $colName column. If you leave the value empty, it will return the whole column."
                read -r -p "Enter the current value: " currentValue
                if [[ -f ~/DBMS-Bash-Project/Scripts/deleteAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/deleteAll.sh "$tableName" "$colIndex" "$currentValue"
                else
                    echo "deleteAll.sh script not found!"
                fi
            fi
            break
        elif [[ "$colName" == "DeleteAll" ]]; then
            echo "${tableValue[@]}"
            echo "You are attempting to delete all records in the table."
            if [[ -f ~/DBMS-Bash-Project/Scripts/deleteAll.sh ]]; then
                . ~/DBMS-Bash-Project/Scripts/deleteAll.sh "$tableName" "DeleteAll"
            else
                echo "deleteAll.sh script not found!"
            fi
            break
        else
            echo "Invalid selection, try again."
        fi
    done
}
DeleteMenu
