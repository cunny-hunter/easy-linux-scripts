#!/bin/bash

# Specify the root folder where you want to start the operation
root_folder="$HOME/.mozilla/firefox/"

# Function to delete files and folders inside each subfolder
delete_files_and_folders() {
    local folder="$1"

    # Enter the subfolder
    cd "$folder" || exit 1

    # Delete specific files (customize as needed)
    rm -f "sessionstore.jsonlz4"
    rm -f "sessionCheckpoints.json"

    # Delete specific folders (customize as needed)
    cd "sessionstore-backups"
    rm -rf *

    # Go back to the parent folder
    cd ..
}

# Find folders with names separated by a dot and iterate over them
find "$root_folder" -type d -name "*.*" | while read -r folder; do
    echo "Processing folder: $folder"
    delete_files_and_folders "$folder"
done

