#! /usr/bin/env bash
# shopt -s extglob
echo "Enter The DataBase Name you want to Delete:"
read DDB
if [[ ! -e ~/DBMS/DataBase/$DDB ]]; then
     echo "There Is no Data Base With Such Name"
else

     echo "are you sure you want to delete This DB ${DDB}"
     read answer
     if [[ $answer == "yes" ]]; then
          rm -r ~/DBMS/DataBase/$DDB
     fi
fi
