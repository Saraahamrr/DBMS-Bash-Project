#! /usr/bin/bash
shopt -s extglob # Enable extended pattern matching
function updateAll() {
    # Initialize variables
    colIndex=$(($1 + 1)) # Column index passed as first parameter
    oldValue=$2          # Value to find
    newValue=$3          # Value to replace with
    tableName=$4         # Table name (file)
    PK=$5
    # Ensure the required variables are not empty
    if [[ -z "$oldValue" || -z "$newValue" || -z "$tableName" || -z "$colIndex" ]]; then
        echo "The Value must not be empty."
        . ~/DBMS-Bash-Project/Scripts/updateTable.sh
    fi

    # Use awk to find and modify the column value
    oldValueLocation=$(
        awk -v colIndex="${colIndex}" -v oldValue="${oldValue}" -v newValue="${newValue}" '
    BEGIN { FS = ":"; OFS = ":" }
    {
        if ($colIndex == oldValue) {
            $colIndex = newValue  # Update the value in the column
            print $0  # Print the modified line
        }
    }' ~/DBMS-Bash-Project/DataBase/DB1/$tableName
    )
    Dublicate=$(
        awk -v colIndex="${colIndex}" -v oldValue="${oldValue}" -v newValue="${newValue}" '
    BEGIN { FS = ":"; OFS = ":" }
    {
        if ($colIndex == newValue) {
            # $colIndex = newValue  # Update the value in the column
            print $0  # Print the modified line
        }
    }' ~/DBMS-Bash-Project/DataBase/DB1/$tableName
    )
    #Dublicate
    echo "${Dublicate}"
    if [[ -n "$PK" && -n "$Dublicate" ]]; then
        echo "Sorry You Enterd Dublicated Primary Key Primary Key Must Be uniqe"
    # Bshof law
    else
        if [[ -n "$oldValueLocation" ]]; then
            # Update the file with sed, ensuring proper escaping for special characters
            sed -i "s/${oldValue}/${newValue}/g" ~/DBMS-Bash-Project/DataBase/DB1/$tableName

            echo "File updated successfully."
        else
            echo "Not Found"

        fi
    fi
}
updateAll $1 $2 $3 $4 $5
# # Check if the line was found and update the file
