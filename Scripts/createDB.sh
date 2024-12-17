#! /usr/bin/env bash
# shopt -s extglob
#REGEX Needed
function createDB() {
    echo "Enter the name of the database to create:"
    read -r dbName
    if [[ -e $dbName ]] && [[ -d ~/DBMS/DataBase/$dbName ]]; then
        echo "Already Exitst"
    else
        echo "DataBase Has Been Created"
        mkdir -p ~/DBMS/DataBase/"${dbName}" && echo "Database '$dbName' created successfully." || echo "Failed to create database."
    fi
}
createDB
