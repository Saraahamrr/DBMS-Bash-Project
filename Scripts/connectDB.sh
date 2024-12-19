#! /usr/bin/env bash
# shopt -s extglob
#REGEX Needed
function selectDB() {
    echo "Enter the name of the database to Connect:"
    read -r dbName
    if [[ -e ~/DBMS-Bash-Project/DataBase/$dbName ]] && [[ -d ~/DBMS-Bash-Project/DataBase/$dbName ]]; then
        echo "Connected To ${dbName}"
        cd "${PWD}"/"${dbName}/" 2>>/dev/null
        . ~/DBMS-Bash-Project/Scripts/./tableMenu.sh
        
    else
        echo -e "Database '$dbName' does not exist \nDo you want to Create DB?"
        read answer
        if [[ $answer == [Yy][Ee][Ss] ]]; then
            . ~/DBMS-Bash-Project/Scripts/createDB.sh
        fi
    fi
}
selectDB

