#! /usr/bin/env bash
# shopt -s extglob
#REgex
function tableMenu() {
    while true; do
        echo "Table Main Menu: "
    
        select option in CreateTable ListTables SelectTable insert update Delete Exit; do
            case $option in
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
            "Insert" | "4")
                break
                ;;
            "Update" | "5")

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

tableMenu
