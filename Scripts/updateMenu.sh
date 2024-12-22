#! /bin/bash
shopt -s extglob # Enable extended pattern matching
clear

function UpdateMenu() {
    # bgyb al List Bta3t al files
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))

    # bwry al user al list bta3t al Tables al mwgood 3shan nshlha law mwgoda bd5lha law la2 3ala alah
    echo -e "Listing Tables:\n"
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

    # bgyb al table values
    tableValue=($(~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$tableName"))

    # bshof lw fe metadata mwgoda lw msh mwgoda btl3 error
    metadataFile="${PWD}/${tableName}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $tableName. Exiting."
        exit 1
    fi

    # bgm3 al columns we al types mn al metadata
    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    columnType=($(awk -F: '{print $2}' "$metadataFile"))

    echo -e "\nColumns available: ${columnName[@]}"

    # B3ml menu 3shan a5tar al column li 3ayz a update
    echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table*"
    select colName in "${columnName[@]}" "value" "TableMenu" "Exit"; do
        if [[ "$colName" == "Exit" ]]; then
            echo "Exiting updating process."
            break
        elif [[ -n "$colName" && "$colName" != "value" && "$colName" != "TableMenu" ]]; then
            # Bgyb al index Bta3 al column li 3ayz a update
            for i in "${!columnName[@]}"; do
                if [[ "${columnName[$i]}" == "$colName" ]]; then
                    colIndex=$i
                    break
                fi
            done

            # bshof alw al al column da PK bbasy anh Bk 3shan mnf3sh yb2a Mtkrr
            if [[ "$colName" == "${columnName[0]}" ]]; then
                echo "${tableValue[@]}"
                echo "You are attempting to update the Primary Key (PK) column."
                read -r -p "Enter the Primary Key Value: " currentValue
                read -r -p "Enter the new value: " newValue
                # For Primary Key validation

                if [[ (-z "$newValue" || "$newValue" == "0") && (-z "$currentValue" || "$currentValue" == "0") ]]; then
                    echo "ERROR: values cannot be empty,0,Special Charecters."
                elif [[ ! "$newValue" =~ ^[0-9]+$ ]]; then
                    echo "ERROR: Value must be an integer."
                elif [[ "${columnType[$colIndex]}" != "int" && ! "$newValue" =~ ^[a-zA-Z_]+$ ]]; then
                    echo "ERROR: Value must be a string (letters and underscores only)."
                else
                    if . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$tableName" "PK"; then
                        echo "Update successful."
                    else
                        echo "ERROR: Update failed."
                    fi
                fi
            else
                # For other columns
                echo "You are updating the $colName column."
                read -r -p "Enter the current value: " currentValue
                echo -e "\nNOTE: New Value Can't have spaces, Use '_' if needed\n"
                read -r -p "Enter the new value: " newValue
                if [[ -z "$newValue" ]]; then
                    echo "ERROR: New value cannot be empty."
                elif [[ "${columnType[$colIndex]}" == "int" && ! "$newValue" =~ ^[0-9]+$ ]]; then
                    echo "ERROR: Value must be an integer."
                elif [[ "${columnType[$colIndex]}" != "int" && ! "$newValue" =~ ^[a-zA-Z_]+$ ]]; then
                    echo "ERROR: Value must be a string (letters and underscores only)."
                else
                    if . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$tableName"; then
                        echo ":)"
                    else
                        echo "ERROR: Update failed."
                    fi
                fi
            fi
            break
        elif [[ "$colName" == "value" ]]; then
            echo "${tableValue[@]}"
            echo -e "\nSelect the column to update its values:"
            echo "Select Specific Record. Enter 2 values: PK and the value you want to change."
            read -r -p "Enter the Primary Key value: " PK
            read -r -p "Enter the current value: " currentValue
            echo -e "\nNOTE: New Value Can't have spaces, Use '_' if needed\n"
            read -r -p "Enter the new value: " newValue
            if [[ -z "$newValue" ]]; then
                echo "ERROR: New value cannot be empty."
            elif [[ -n $PK && -n $currentValue && -n $newValue ]]; then
                echo "Valid Values "Updating
                . ~/DBMS-Bash-Project/Scripts/updateRecord.sh "$PK" "$currentValue" "$newValue" "$tableName"
            elif [[ -z $PK || -z $currentValue || -z $newValue ]]; then
                echo "InValid Values or Empty"
            else
                . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
            fi
            break
        elif [[ "$colName" == "TableMenu" ]]; then
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

UpdateMenu
