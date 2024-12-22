#!/bin/bash
shopt -s extglob # Enable extended pattern matching

function DeleteMenu() {
    # List files in the current directory, excluding `.meta_data` files
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))

    # Dynamically present the file selection menu
    echo -e "Listing Tables:\n"
    select item in "${list[@]}" "Cancel" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
        elif [[ "$item" == "Cancel" ]]; then
            echo "You selected: $item. Backing to TableMenu."
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

    # Retrieve table values
    tableValue=($(~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$tableName"))

    # Construct the metadata file path
    metadataFile="${PWD}/${tableName}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $tableName. Exiting."
        exit 1
    fi

    # Read column names from the metadata file
    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    columnType=($(awk -F: '{print $2}' "$metadataFile"))

    echo -e "\nColumns available: ${columnName[@]}"

    # Main column selection menu
    echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table*"
    select colName in "${columnName[@]}" "value" "TableMenu" "Exit"; do
        if [[ "$colName" == "Exit" ]]; then
            echo "Exiting selecting process."
            break
        elif [[ -n "$colName" && "$colName" != "value" && "$colName" != "TableMenu" ]]; then
            # Get the index of the selected column
            for i in "${!columnName[@]}"; do
                if [[ "${columnName[$i]}" == "$colName" ]]; then
                    colIndex=$i
                    break
                fi
            done

            # Check if the column is the Primary Key (PK)
            echo "${tableValue[@]}"
            echo "You selected: $colName (Index: $colIndex)"
            if [[ "$colName" == "${columnName[0]}" ]]; then
                echo "You are attempting to delete the Primary Key (PK) column."
                read -r -p "Enter the Primary Key value: " currentValue
                read -r -p "Enter the new value: " newValue
                # Validate the value exists in the file and pass the PK for update
                . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$item" "PK"
            else
                echo "You are deleting the $colName column."
                read -r -p "Enter the current value: " currentValue
                echo -e "\nNOTE: New Value Can't have spaces, Use '_' if needed\n"
                read -r -p "Enter the new value: " newValue
                # Validate the value exists and update the column
                if [[ -f ~/DBMS-Bash-Project/Scripts/updateAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$tableName"
                else
                    echo "updateAll.sh script not found!"
                fi
            fi
            break
        elif [[ "$colName" == "value" ]]; then
            # Select specific records based on a provided value
            echo "${tableValue[@]}"
            echo -e "\nSelect the column to delete its values:"
            echo "Select Specific Record. Enter 2 values: PK and the value you want to change."
            read -r -p "Enter the Primary Key value: " PK
            read -r -p "Enter the current value: " currentValue
            echo -e "\nNOTE: New Value Can't have spaces, Use '_' if needed\n"
            read -r -p "Enter the new value: " newValue
            . ~/DBMS-Bash-Project/Scripts/updateRecord.sh "$PK" "$currentValue" "$newValue" "$tableName"
            break
        elif [[ "$colName" == "TableMenu" ]]; then
            # Return to the Table Menu
            if [[ -f ~/DBMS-Bash-Project/Scripts/tableMenu.sh ]]; then
                . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
            else
                echo "tableMenu.sh script not found!"
            fi
            break
        else
            echo "Invalid selection, try again."
        fi
    done
}

DeleteMenu
