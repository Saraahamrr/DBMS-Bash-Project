#! /usr/bin/env bash
shopt -s extglob
function selectDB() {
    clear
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))
    select item in "${list[@]}" "Cancel" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
        elif [[ "$item" == "Cancel" ]]; then
            echo "You selected: $item Backing to TableMenu"
            . ~/DBMS-Bash-Project/DBScript
            break
        elif [[ -n "$item" ]]; then
            echo "You selected: $item"
            dbName="${item}"
            break
        else
            echo "Invalid selection, try again."
        fi
    done
    if [[ -e ~/DBMS-Bash-Project/DataBase/$dbName ]] && [[ -d ~/DBMS-Bash-Project/DataBase/$dbName ]]; then
        echo "Connected To ${dbName}"
        cd ~/DBMS-Bash-Project/DataBase/$dbName 2>/dev/null
        . ~/DBMS-Bash-Project/Scripts/tableMenu.sh
    else
        echo -e "Database '$dbName' does not exist \nDo you want to Create DB?"
        read answer
        if [[ $answer == [Yy][Ee][Ss] ]]; then
            . ~/DBMS-Bash-Project/Scripts/createDB.sh
        fi
    fi
}
selectDB
