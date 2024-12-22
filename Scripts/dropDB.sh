#! /usr/bin/env bash
# shopt -s extglob
. /home/sarah/DBMS-Bash-Project/Scripts/RegexFunc.sh

echo "Enter The DataBase Name you want to Delete:"
read -r dbname
if check_dbname $dbname ; then
     if [[ ! -e ~/DBMS-Bash-Project/DataBase/$dbname ]]; then
          echo "There Is no Data Base With Such Name"
     else

          echo "are you sure you want to delete the DataBase Named ${dbname}"
          read -r answer
          #REGEX
          if [[ $answer == [Yy][Ee][Ss] ]]; then
               rm -r ~/DBMS-Bash-Project/DataBase/$dbname
          fi
     fi
else
        echo "Invalid DataBase Name"
fi 
