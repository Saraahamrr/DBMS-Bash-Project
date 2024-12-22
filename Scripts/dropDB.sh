#! /usr/bin/env bash
shopt -s extglob
. ~/DBMS-Bash-Project/Scripts/RegexFunc.sh
function DropDB() {
     clear
     echo "Enter The DataBase Name you want to Delete:"
     read -r dbname
     if check_dbname $dbname; then
          if [[ ! -e ~/DBMS-Bash-Project/DataBase/$dbname ]]; then
               echo "There Is no Data Base With Such Name"
          else

               echo "are you sure you want to delete the DataBase Named (Yes/No) ${dbname}"
               read -r answer
               #REGEX
               if [[ $answer == [Yy][Ee][Ss] ]]; then
                    rm -r ~/DBMS-Bash-Project/DataBase/$dbname
               fi
          fi
     else
          echo "Invalid DataBase Name"
     fi
}
DropDB
