#! /usr/bin/env bash
shopt -s extglob
#REgex
Welcome
function tableMenu() {
    while true; do
        echo "Main Menu:"
        cd ~/DBMS-Bash-Project/DataBase
        select option in CreateTable ListTables SelectTable insert update delete Exit,; do
            case $REPLY in
             [Cc][Rr][Ee][Aa][Tt][Ee][Dd][Tt][Aa][Bb][Ll][Ee] | "1")
                echo
                break
                ;;
            [Ll][Ii][Ss][Tt][Tt][Aa][Bb][Ll][Ee] | "2")
                break
                ;;
            [Ss][Ee][Ll][Ee][Cc][Tt][Tt][Aa][Bb][Ll][Ee] | "3")
                break
                ;;
            [Ii][Nn][Ss][Ee][Rr][Tt] | "4")
                break
                ;;
            [Uu][Pp][Dd][Aa][Tt][Ee] | "5")

                break
                ;;
            [Dd][Ee][Ll][Ee][Tt][Ee] | "6")

                break
                ;;
            [Ee][Xx][Ii][Tt] | "7")
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
