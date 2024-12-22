#!/bin/bash
shopt -s extglob # Enable extended pattern matching

function SelectMenu() {
    # List files in the current directory, excluding `.meta_data` files
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))

    # Dynamically present the file selection menu
    echo -e "Listing Files:\n"
    select item in "${list[@]}" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
        elif [[ -n "$item" ]]; then
            echo "You selected: $item"
            choice="${item}"
            break
        else
            echo "Invalid selection, try again."
        fi
    done

    # Construct the metadata file path
    metadataFile="${PWD}/${choice}.meta_data"
    if [[ ! -f "$metadataFile" ]]; then
        echo "Metadata file not found for $choice. Exiting."
        echo -e "Are you sure you want to Drop the Table Named ${dbname} ? \nNOTE: knowing It doesn't have a metadata"
          read -r answer
          #REGEX
          if [[ $answer == [Yy][Ee][Ss] ]]; then
               rm -r "${PWD}/${choice}"
               echo "Dropped Table $choice Successfully"
          fi
        exit 1
    fi

    # Read column names from the metadata file
    columnName=($(awk -F: '{print $1}' "$metadataFile"))
    echo -e "Columns available: ${columnName[@]}"

    # Main column selection menu
    echo -e "\nListing Columns\nIf you choose a column, you will delete in that column."
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
            if [[ "$colName" == "${columnName[0]}" ]]; then
                echo -e "\nListing Columns\nIf you choose a column, you will delete in that column."
                . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$item"
                echo "You are attempting to delete the Primary Key (PK) column. If you leave the value empty, it will return the whole column."
                read -r -p "Enter the Primary Key value: " currentValue
                if [[ -f ". ~/DBMS-Bash-Project/Scripts/deleteAll.sh" ]]; then
                    ". ~/DBMS-Bash-Project/Scripts/deleteAll.sh" "$item" "$colIndex" "$currentValue"
                else
                    echo "selectAll.sh script not found!"
                fi
            else
            echo -e "\nListing Columns\nIf you choose a column, you will delete in that column."
                . ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh "$item"
                echo "You are selecting the $colName column. If you leave the value empty, it will return the whole column."
                read -r -p "Enter the current value: " currentValue
                if [[ -f "~/DBMS-Bash-Project/Scripts/deleteAll.sh " ]]; then
                    . ~/DBMS-Bash-Project/Scripts/deleteAll.sh "$item" "$colIndex" "$currentValue"
                else
                    echo "selectAll.sh script not found!"
                fi
            fi
            break
        elif [[ "$colName" == "DeleteAll" ]]; then
            ". ~/DBMS-Bash-Project/Scripts/reUsableSelect.sh"
            echo "You are attempting to delete all records in the table."
            if [[ -f ~/DBMS-Bash-Project/Scripts/selectAll.sh ]]; then
                . ~/DBMS-Bash-Project/Scripts/deleteAll.sh "$item" "DeleteAll"
            else
                echo "selectAll.sh script not found!"
            fi
            break
        else
            echo "Invalid selection, try again."
        fi
    done
}

SelectMenu
