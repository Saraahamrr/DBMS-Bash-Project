#! /usr/bin/env bash
# shopt -s extglob
#REGEX Needed
function selectDB() {
    # Prompt user to enter the table name
    echo "Enter the Number of the DataBase to Connect:"
    list=($(ls "${PWD}" | grep -v '\.meta_data$'))
    echo -e "Listing Files:\n"
    select item in "${list[@]}" "Exit"; do
        if [[ "$item" == "Exit" ]]; then
            echo "Exiting program."
            exit 0
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
