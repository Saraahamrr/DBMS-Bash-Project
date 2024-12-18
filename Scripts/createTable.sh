#! /usr/bin/bash
 shopt -s extglob # Enable extended pattern matching
function createTable() {
   Thepri
    function createTable() {

        echo "Enter Table Name:"
        read -r Tname

        if [[ -e "${PWD}/$Tname" ]]; then
            echo "Table '$Tname' already exists."
            return
        fi

        while true; do
            echo "Enter Number Of Columns:"
            read -r colNum
            if [[ $colNum =~ ^[1-9][0-9]*$ ]]; then
                break
            else
                echo "Invalid input. Please enter a positive integer for the column count."
            fi
        done

        declare -i num=0
        pk=false
        tableSchema=""

        echo "The first column will be the Primary Key (PK)."
             echo "${tableSchema} 1"
        while ((num < colNum)); do
               echo "${tableSchema} 1"
            echo "Enter Column $((num + 1)) Name:"
            read -r colName
            if [[ ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                echo "Invalid column name. Use letters, numbers, and underscores only."
                continue
            fi
            echo "Enter Column $((num + 1)) Datatype (int/str):"
            read -r colType
            if [[ $colType != "int" && $colType != "str" ]]; then
                echo "Invalid datatype. Only 'int' or 'str' are allowed."
                continue
            fi
                   echo "${tableSchema} 1"
            if [[ $pk -eq false ]]; then

                tableSchema+="${colName}:${colType}:PK\n"

                pk=true
            else

                tableSchema+="$colName:$colType\n"
            fi
            echo "${tableSchema} 4 "

            ((num++))
        done
      
        touch   "${Tname}.meta_data"
        touch   "${Tname}"
        echo -e "${tableSchema}" > "${Tname}.meta_data"
        echo    "Table ${Tname} Successfuly Created"
    }

    createTable

}

createTable



