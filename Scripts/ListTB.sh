#!/bin/bash
shopt -s extglob

# if without ^"-" it will retrieve 3 cause the total size is the first line of ls -l
function listTB() {
    clear
    databases_number=$(ls -l | grep "^f" | awk '{print $NF}' | wc -l)

    if [ "$databases_number" -gt 0 ]; then # quoted to insure there's no errors in handling int
        echo "Databases count : $databases_number"
    else
        echo "No databases yet"
    fi

    ls -l | grep "^d" | awk '{print $NF}' # last feild
}
listTB
