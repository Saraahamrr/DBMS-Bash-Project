#! /usr/bin/env bash
shopt -s extglob


databases_number=$(ls -l | grep "^d" | awk '{print $NF}' | wc -l)

if [ "$databases_number" -gt 0 ]; then # quoted to insure there's no errors in handling int
    echo "Databases count : $databases_number"
else
    echo "No databases yet"
fi


ls -l | grep "^d" | awk '{print $NF}' # last feild