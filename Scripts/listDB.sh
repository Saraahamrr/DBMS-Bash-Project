#! /usr/bin/env bash
#shopt -s extglob
function listDataBase() {
    if [ "$(ls ~/DBMS-Bash-Project/DataBase)" ]; then
        echo -e "Existing :$(ls ~/DBMS-Bash-Project/DataBase | wc -l) \n$(ls ~/DBMS-Bash-Project/DataBase) \n "
    else
        echo -e "No Files Existing :\n$(ls ~/DBMS-Bash-Project/DataBase)" 2>>/dev/null
    fi

    ### why use 2 .... maybe we can     echo -e "No Files Existing :\n$(ls ${~/DBMS-Bash-Project/DataBase})" 2>>/dev/null
    ### fixed -e to make it read \n
}
listDataBase
