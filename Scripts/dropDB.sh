#! /usr/bin/env bash
# shopt -s extglob
#REGEX Needed
echo "Enter The DataBase Name you want to Delete:"
read -r DDB
if [[ ! -e ~/DBMS-Bash-Project/DataBase/$DDB ]]; then
     echo "There Is no Data Base With Such Name"
else

     echo "are you sure you want to delete This DB ${DDB}"
     read -r answer
     #REGEX
     if [[ $answer == [Yy][Ee][Ss] ]]; then
          rm -r ~/DBMS-Bash-Project/DataBase/$DDB
     fi
fi
