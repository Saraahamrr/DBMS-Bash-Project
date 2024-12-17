#! /usr/bin/env bash
#shopt -s extglob

if [ "$(ls ${PWD}/ | wc -l)" -gt 0 ]; then
    echo "Existing :$(ls ${PWD}/* | wc -l) \n$(ls ${PWD}) \n "
else
    echo "No Files Existing :\n$(ls ${PWD})"
fi
