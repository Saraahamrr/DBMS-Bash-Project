#!/usr/bin/bash
shopt -s extglob # Enable extended pattern matching
clear
function createTable() {
    while true; do
        read -r -p "Enter Table Name: " Tname
        if [[ ! $Tname =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "Invalid table name. Use letters, numbers, and underscores only."
            continue
        fi
        if [[ ! -e "${PWD}/$Tname" ]]; then
            while true; do
                read -r -p "Enter ${Tname} Columns Number: " colNum
                if [[ $colNum =~ ^[1-9][0-9]*$ ]]; then
                    break
                else
                    echo "Invalid input. Please enter a positive integer for the column count."
                fi
            done
            echo -e "Creating table '$Tname' with $colNum columns..."
            break
        elif [[ -e "${PWD}/$Tname" && -f "${PWD}/$Tname" ]]; then
            echo "Table '$Tname' already exists. Choose another name."
        else
            echo "'$Tname' exists as a directory. Recreating your table as a file..."
            rm -r "${PWD}/${Tname}"
            while true; do
                read -r -p "Enter Columns Number: " colNum
                if [[ $colNum =~ ^[1-9][0-9]*$ ]]; then
                    break
                else
                    echo "Invalid input. Please enter a positive integer for the column count."
                fi
            done
            echo -e "Creating table '$Tname' with $colNum columns..."
            break
        fi
    done

    declare -i num=0
    pkFlag=0
    tableSchema=""
    echo "The first column will be the Primary Key (PK)."
    while ((num < colNum)); do
        read -r -p "Enter Column $((num + 1)) Name: " colName
        if [[ ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "Invalid column name. Use letters, numbers, and underscores only."
            continue
        fi

        read -r -p "Enter Column $((num + 1)) Datatype (int/str): " colType
        if [[ $colType != "int" && $colType != "str" ]]; then
            echo "Invalid datatype. Please choose either 'int' (integer) or 'str' (string)."
            continue
        fi

        if [[ $pkFlag -eq 0 ]]; then
            tableSchema+="${colName}:${colType}:PK\n"
            pkFlag=1
        else
            tableSchema+="${colName}:${colType}\n"
        fi
        ((num++))
    done

    touch "${Tname}.meta_data"
    touch "${Tname}"
    echo -e "${tableSchema}" >"${Tname}.meta_data"
    echo -e "Table '${Tname}' successfully created with $colNum columns."
}

createTable
