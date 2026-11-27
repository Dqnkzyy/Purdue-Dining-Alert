#!/usr/bin/env bash

# stop if the favorites list is missing or unreadable
if [[ ! -r favorites.txt ]]; then
    echo "Could not read favorites.txt. Add one favorite food per line." >&2
    exit 1
fi

# skip blank lines so they don't match every food
favorites=$(grep '[^[:space:]]' favorites.txt)
grep_status=$?

# checks if grep equals 1, which means no nonblank lines were found in favorites.txt, and exits with a message to add at least one food to the file. If grep returns a non-zero status that is not 1, it exits with an error code of 1.
if [[ $grep_status -eq 1 ]]; then
    echo "Add at least one food to favorites.txt."
    exit 0
# checks if grep returns non-zero number that is not 1, which means an error
elif [[ $grep_status -ne 0 ]]; then
    exit 1
fi


# get the date once so every court is checked for the same day
menu_date=$(date +%F)

# fetch menu data per dining hall
for hall in Earhart Ford Hillenbrand Wiley Windsor; do

    # ends script if fails to fetch menu data, sS clears loading bars, f prevents printing HTML errors
    menu_json=$(curl -fsS "https://api.hfs.purdue.edu/menus/v2/locations/$hall/$menu_date") || exit 1

    # extract all menu items from the JSON response
    foods=$(printf '%s\n' "$menu_json" | jq -r '.Meals[].Stations[].Items[].Name')

    # match favorites against food names only
    while read -r food; do
        # check whether the food name contains any favorite
        if grep -Fiq -f <(printf '%s\n' "$favorites") <<< "$food"; then
            # include hall to know where to find the food
            printf '%s — %s\n' "$hall" "$food"
        fi
    done <<< "$foods"
# keep only one copy of each identical line using sort -u to remove duplicates
done | sort -u