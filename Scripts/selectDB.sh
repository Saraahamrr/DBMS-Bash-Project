#! /usr/bin/env bash
# shopt -s extglob
function selectDB() {
    echo "Enter the name of the database to seleact:"
    read -r dbName
    if [[ -e ~/DBMS/DataBase/$dbName ]] && [[ -d ~/DBMS/DataBase/$dbName ]]; then
        echo "Database '$dbName' selected."
        cd ~/DBMS/DataBase/$dbName || exit
    else
        echo "Database '$dbName' does not exist \nDo you want to Create DB"
        read answer
        if [[ $answer == "yes" ]]; then
            . ~/DBMS/Scripts/createDB.sh
        fi
    fi
}
selectDB
