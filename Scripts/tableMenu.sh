#! /usr/bin/env bash
shopt -s extglob

function tableMenu() {
    PS3="SelectOption $:"
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
                . ~/DBMS-Bash-Project/Scripts/listingTable.sh
                break
                ;;
            "SelectTable" | "3")
                echo "Selecting data..."
                . ~/DBMS-Bash-Project/Scripts/selectMenu.sh
                break
                ;;
            "Insert" | "4")
                echo "Inserting data..."
                . ~/DBMS-Bash-Project/Scripts/insertTable.sh
                break
                ;;
            "Update" | "5")
                echo "Updating table..."
                . ~/DBMS-Bash-Project/Scripts/updateMenu.sh
                break
                ;;
            "Delete" | "6")
                echo "Deleting table..."
                . ~/DBMS-Bash-Project/Scripts/deleteMenu.sh
                break
                ;;
            "DataBaseMenu" | "7")
                echo "Returning to Database Menu..."
                ~/DBMS-Bash-Project/DBScript
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
