#!/bin/bash
shopt -s extglob # Enable extended pattern matching

function SelectMenu() {
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))
    echo -e "Listing Files:\n"
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
    echo "${tableValue}"
    metadataFile="${PWD}/${tableName}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $tableName. Exiting."
        . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
    fi

    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    echo -e "Columns available: ${columnName[@]}"

    ##echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table*"
    select colName in "${columnName[@]}" "Select*" "value" "TableMenu" "Exit"; do
        if [[ "$colName" == "Exit" ]]; then
            echo "Exiting Selecting process."
            break
        elif [[ -n "$colName" && "$colName" != "value" && "$colName" != "Select*" && "$colName" != "TableMenu" ]]; then
            for i in "${!columnName[@]}"; do
                if [[ "${columnName[$i]}" == "$colName" ]]; then
                    colIndex=$((i + 1)) # Make it 1-based index for awk
                    break
                fi
            done
            echo "You selected: $colName (Index: $colIndex)"

            if [[ "$colName" == "${columnName[0]}" ]]; then
                echo "You are attempting to update the Primary Key (PK) column. If you leave the value empty, it will return the whole column."
                echo "${tableValue}"
                read -r -p "Enter the Primary Key value: " currentValue
                if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/selectAll.sh "$tableName" "$colIndex" "$currentValue"
                else
                    echo "selectAll.sh script not found!"
                fi
            else
                echo "${tableValue[@]}"
                echo "You are selecting the $colName column. If you leave the value empty, it will return the whole column."
                read -r -p "Enter the current value: " currentValue
                if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/selectAll.sh "$tableName" "$colIndex" "$currentValue"
                else
                    echo "selectAll.sh script not found!"
                fi
            fi
            break
        elif [[ "$colName" == "Select*" ]]; then
            if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
                . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$tableName" "selectAll"
            else
                echo "reUsableSelect.sh script not found!"
            fi
            break
        elif [[ "$colName" == "value" ]]; then
            . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh
            echo -e "\nSelect the column to update its values:"
            echo "Select a specific record by entering 2 values: PK and the value you want to Select ."
            read -r -p "Enter the Primary Key value: " PK
            read -r -p "Enter the current value: " currentValue
            echo "$PK  $currentValue  $tableName"
            if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
                . ~/DBMS-Bash-Project/Scripts/selectAll.sh "$tableName" "$colIndex" "$currentValue"
            else
                echo "selectAll.sh script not found!"
            fi
        elif [[ "$colName" == "TableMenu" ]]; then
            if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
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

SelectMenu
