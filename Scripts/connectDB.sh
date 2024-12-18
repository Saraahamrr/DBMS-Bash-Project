#! /usr/bin/env bash
# shopt -s extglob
#REGEX Needed
function selectDB() {
<<<<<<< HEAD
    echo "Enter the name of the database to select:"
=======
    echo "Enter the name of the database to Connect:"
>>>>>>> af50f2c (DBMS Update 2)
    read -r dbName
    if [[ -e ~/DBMS-Bash-Project/DataBase/$dbName ]] && [[ -d ~/DBMS-Bash-Project/DataBase/$dbName ]]; then
        echo "Database '$dbName' selected."
<<<<<<< HEAD
        cd ~/DBMS-Bash-Project/DataBase/$dbName 2>>/dev/null
=======
        cd ~/DBMS/DataBase/"${dbName}/" 2>>/dev/null
        echo "${PWD}"
        . ~/DBMS/Scripts/./tableMenu.sh
        
>>>>>>> af50f2c (DBMS Update 2)
    else
        echo -e "Database '$dbName' does not exist \nDo you want to Create DB?"
        read answer
        if [[ $answer == [Yy][Ee][Ss] ]]; then
            . ~/DBMS-Bash-Project/Scripts/createDB.sh
        fi
    fi
}
selectDB
