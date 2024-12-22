#! /usr/bin/env bash
shopt -s extglob
#REGEX Needed

. /home/sarah/DBMS-Bash-Project/Scripts/RegexFunc.sh

function createDB() {
    echo "Enter the name of the database to create:"
    read -r dbname
    if check_dbname "$dbname"; then
        if [[ -e $dbname ]] && [[ -d ~/DBMS-Bash-Project/DataBase/$dbname ]]; then
            echo "Already Exitst"
        else
            mkdir -p ~/DBMS-Bash-Project/DataBase/"${dbname}" && echo "Database '$dbname' created successfully." || echo "Failed to create database."
        fi
    else
        echo "Invalid DataBase Name"
    fi
}
createDB
