#!/bin/bash
shopt -s extglob # Enable extended pattern matching

function UpdateMenu() {
    # bgyb al List Bta3t al files
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))
    # bwry al user al list bta3t al Tables al mwgood 3shan nshlha law mwgoda bd5lha law la2 3ala alah
    echo -e "Listing Tables:\n"
    select item in "${list[@]}" "<-Back" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
        elif [[ -n "$item" ]]; then
            echo "You selected: $item"
            choice="${item}"
            break
        elif [[ "$item" == "Back" ]]; then
            echo "Exiting program."
            . "~/DBMS-Bash-Project/Scripts/tableMenu.sh"
        else
            echo "Invalid selection, try again."
        fi
    done

    # Construct the metadata file path
    metadataFile="${PWD}/${choice}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $choice. Exiting."
        exit 1
    fi

    # Read column names from the metadata file
    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    echo -e "\nColumns available: ${columnName[@]}"

    # Main column selection menu
    echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table*"
    select colName in "${columnName[@]}" "value" "Exit"; do
        if [[ "$colName" == "Exit" ]]; then
            echo "Exiting updating process."
            break
 ################################################################################################################################
        elif [[ -n "$colName" && "$colName" != "value" ]]; then
            # Bgyb al index Bta3 a We BRKM AL SELECT
            for i in "${!columnName[@]}"; do
                if [[ "${columnName[$i]}" == "$colName" ]]; then
                    colIndex=$i
                    break
                fi
            done
            echo "You selected: $colName (Index: $colIndex)"
            # bshof alw al al column da PK bbasy anh Bk 3shan mnf3sh yb2a Mtkrr
            if [[ "$colName" == "${columnName[0]}" ]]; then
            echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table"
                . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$item"
                echo "You are attempting to update the Primary Key (PK) column."
                read -r -p "Enter the PrimaryKey Value: " currentValue
                echo -e "\nNOTE: New Value Can't have spaces,Use "_" if needed\n"
                read -r -p "Enter the new value: " newValue
                #Ba5od al value we bt2kd anha F3la Mwgoda fe al file
                #we bb3t al file bel Pk we al index 3shan ast5dmo Ka filed fe al AWK
                . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$item" "PK"
########################################################################################################################################
            else
                echo "You are updating the $colName column."
                read -r -p "Enter the current value: " currentValue
                echo -e "\nNOTE: New Value Can't have spaces,Use "_" if needed\n"
                read -r -p "Enter the new value: " newValue
                #Ba5od al value we bt2kd anha F3la Mwgoda fe al file
                #we bb3t al file bel index 3shan ast5dmo Ka filed fe al AWK we msh bb3t al Pk
                if [[ -f ~/DBMS-Bash-Project/Scripts/updateAll.sh ]]; then
                    . ~/DBMS-Bash-Project/Scripts/updateAll.sh "$colIndex" "$currentValue" "$newValue" "$item"
                else
                    echo "updateRecord.sh script not found!"
                fi
            fi
            break
        elif [[ "$colName" == "value" ]]; then
            #ba5od mn al User Spicific Value we a3ml Comparison Bel Awl File_Name()
            #btlob mn al user Yd5ly al value 3ala tool 3shan mfysh Select we bkarn alvalue mwgoda wala la2
            echo -e "\nListing Columns\nIf you choose a column, you will update that column.\n*Note: It is not wise to change the PK of a table"
            . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$item"
            #echo -e "\nSelect the column to update its values:"
            echo -e "\nSelect Spicfic Record Enter 2 values PK and the value you want to Change\n"
            read -r -p "Enter the Primary Key value: " PK
            read -r -p "Enter the current value: " currentValue
            echo -e "\nNOTE: New Value Can't have spaces,Use "_" if needed\n"
            read -r -p "Enter the new value : " newValue
            echo "$PK  $currentValue $newValue $item"
            . ~/DBMS-Bash-Project/Scripts/updateRecord.sh "$PK" "$currentValue" "$newValue" "$item"

            break

            break
        else
            echo "Invalid selection, try again."
        fi
    done
}

UpdateMenu
