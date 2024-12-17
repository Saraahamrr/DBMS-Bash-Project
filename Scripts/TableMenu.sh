#! /usr/bin/env bash
shopt -s extglob
#REgex
Welcome
function mainMenu() {
    while true; do
        echo "Main Menu:"
        cd ~/DBMS/DataBase
        select option in "CreateDB" "ListDB" "SelectDB" "DropDB" "test" "Exit"; do
            case $REPLY in
            "CreateTable" | "1")
                echo
                break
                ;;
            "ListTables" | "2")
                break
                ;;
            "SelectTable" | "3")
                break
                ;;
            "insert" | "4")
                break
                ;;
            "update" | "5")

                break
                ;;
            "Delete" | "6")

                break
                ;;
            "Exit" | "7")
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                break
                ;;
            esac
        done
    done
}

mainMenu
