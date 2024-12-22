#!/bin/bash
shopt -s extglob

# if without ^"-" it will retrieve 3 cause the total size is the first line of ls -l

function listTB(){
    Tables_number=$( ls -l | grep "^-" | grep -v "\.meta_data"  | awk '{print $NF}' | wc -l )

    if [ "$Tables_number" -gt 0 ]; then # quoted to insure there's no errors in handling int
        echo "Tables count : $Tables_number"
    else
        echo "No Tables yet"
    fi

    ls -l | grep "^-" | grep -v "\.meta_data"  | awk '{print $NF}'
}

listTB