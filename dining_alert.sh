#!/usr/bin/env bash

# get the date once so every court is checked for the same day
menu_date=$(date +%F)

# fetch menu data per dining hall
for hall in Earhart Ford Hillenbrand Wiley Windsor; do

    # ends script if fails to fetch menu data
    curl -f "https://api.hfs.purdue.edu/menus/v2/locations/$hall/$menu_date" || exit 1

    # new line after each response
    printf '\n'
done