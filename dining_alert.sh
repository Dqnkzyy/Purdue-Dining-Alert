#!/usr/bin/env bash

# get the date once so every court is checked for the same day
menu_date=$(date +%F)

# fetch menu data per dining hall
for hall in Earhart Ford Hillenbrand Wiley Windsor; do

    # ends script if fails to fetch menu data, sS clesrs loading bars, f prevents printing HTML errors
    menu_json=$(curl -fsS "https://api.hfs.purdue.edu/menus/v2/locations/$hall/$menu_date") || exit 1

    # keep dining hall name alongside every menu item
    printf '%s\n' "$menu_json" | jq -r --arg hall "$hall" '.Meals[].Stations[].Items[].Name | "\($hall) — \(.)"'
done