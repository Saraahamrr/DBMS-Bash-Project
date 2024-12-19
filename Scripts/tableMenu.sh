#! /usr/bin/env bash
shopt -s extglob
#REgex
function tableMenu() {
    SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
    echo "${SCRIPT_DIR}"
    PS1="SelectOption$ "
    loop=true
   #!/usr/bin/env bash

# Main Menu Loop
while true; do
    echo "Table Main Menu: "
    select option in CreateTable ListTables SelectTable Insert Update Delete DataBaseMenu Exit; do
        case $option in
            "CreateTable" | "1")
                echo "Executing CreateTable..."
                . ~/DBMS-Bash-Project/Scripts/createTable.sh
                break
                ;;
            "ListTables" | "2")
                echo "Listing tables..."
                # Add logic to list tables here
                break
                ;;
            "SelectTable" | "3")
                echo "Selecting table..."
                # Add logic to select a table here
                break
                ;;
            "Insert" | "4")
                echo "Inserting data..."
                . ~/DBMS-Bash-Project/Scripts/insertTable.sh
                break
                ;;
            "Update" | "5")
                echo "Updating table..."
                # Add logic to update table here
                break
                ;;
            "Delete" | "6")
                echo "Deleting table..."
                # Add logic to delete table here
                break
                ;;
            "DataBaseMenu" | "7")
                echo "Returning to Database Menu..."
                # Add logic to go back to the database menu
                break
                ;;
            "Exit" | "8")
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
done

}

tableMenu
