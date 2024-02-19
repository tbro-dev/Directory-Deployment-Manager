#!/bin/bash

# Setting debug mode
if [[ "$1" == "debug" || "$1" == "Debug" ]]; then
    set -x
    echo "Debug mode is on."
else
    echo "Normal mode is on."
fi

echo "Starting..."

# Colors for displaying user input
blue="\033[0;36m"
green="\033[0;32m"
yellow="\033[1;33m"
reset="\033[0m"
title="Directory Deployment Manager"

# Function to display user options
displayUserOptions() {    
    echo -e "${blue}==============================================================${reset}"
    echo -e "${blue}|${reset}      ${green}${title}${reset}"
    echo -e "${blue}==============================================================${reset}"
    local options=("Promote Application" "Rollback Application" "Display Application Version History" "EXIT")
    for i in "${!options[@]}"; do
        echo -e "${blue}|${reset} $((i+1)). ${yellow}${options[i]}${reset}"
    done
    echo -e "${blue}==============================================================${reset}"
    echo -e "${blue}|${reset} Please select an option (1-${#options[@]}): "
    echo -e "${blue}==============================================================${reset}"
}

# Function to capture user option
captureUserOption() {
    read -r user_option_input
    echo "${user_option_input}"
}

# Function to handle moving the application
moveApplication() {     
    local source_dir="$1"
    local destination_dir="$2"
    local user_response

    # Check if the source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Source directory $source_dir does not exist!"
        return 1 # Exit function if source does not exist
    fi

    # Ensure the destination directory exists
    if [ ! -d "$destination_dir" ]; then
        echo "Destination directory $destination_dir does not exist. Creating it..."
        sudo mkdir -p "$destination_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create destination directory $destination_dir."
            return 1
        fi
    fi

    echo "Moving $source_dir to $destination_dir..."
    sudo mv "$source_dir" "$destination_dir" && echo "Successfully moved $source_dir to $destination_dir." || echo "Failed to move $source_dir to $destination_dir."
}

# Function to handle displaying application version history
displayVersionHistory() {
    local file_path="./path.txt"
    if [ -f "$file_path" ]; then
        echo -e "${blue}==============================================================${reset}"
        echo -e "${blue}|${reset} Application Version History"
        echo -e "${blue}==============================================================${reset}"
        cat "$file_path"
    else
        echo "Version history file does not exist."
    fi
}

# Function to write action history to file
writeHistory() {
    local action_message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $action_message" >> ./path.txt
}

# Function to define paths
pathDefinition() {
    local file_path="./path.txt"
    local file_exists=false
    
    echo -e "${blue}==============================================================${reset}"

    if [ -f "$file_path" ]; then
        echo "the file ./path.txt exists"
        file_exists=true
    else
        echo "The file was not available, lets create one to support the application"
        file_exists=false
    fi

    if [ $file_exists == true ]; then
        validatePath "staging_path"
        validatePath "production_path"
        validatePath "archive_path"        
    else
        echo -e "${blue}==============================================================${reset}"
        read -p "Enter the path for the staging folder: " staging_path
        read -p "Enter the path for the production folder: " production_path
        read -p "Enter the path for the archive folder: " archive_path

        echo "staging_path=$staging_path" > ./path.txt
        echo "production_path=$production_path" >> ./path.txt
        echo "archive_path=$archive_path" >> ./path.txt

        echo "You have listed the paths below:"
        echo "Staging: $staging_path"
        echo "Production: $production_path"
        echo "Archive: $archive_path"
    fi
}

#Function to validate file path
validatePath() {
    local path_key="$1"                  
    local path_title="${path_key//_/ }"   
     
    echo -e "${blue}==============================================================${reset}"
    
    if grep -q "$path_key" "./path.txt"; then
        local key_contents
        key_contents=$(getPath $path_key)
        echo "${path_title}: ${key_contents}"   
    else
        local user_res
        read -p "Enter $path_title: " user_res
        echo "$path_key=$user_res" >> ./path.txt
    fi
}

# Function to get a path from file
getPath() {
    local path_key="$1"
    echo "$(grep "$path_key" "./path.txt" | cut -d "=" -f 2)"
}

# Function to run the application
runApp() {
    local continue_flag=true
    pathDefinition
    while $continue_flag; do
        displayUserOptions
        local user_selected_option=$(captureUserOption)
        case $user_selected_option in
            1)
                local staging=$(getPath "staging_path")
                local production=$(getPath "production_path")
                local archive=$(getPath "archive_path")
                moveApplication "$production" "$archive" && moveApplication "$staging" "$production" && writeHistory 'Promoted application'
                ;;
            2)
                local staging=$(getPath "staging_path")
                local production=$(getPath "production_path")
                local archive=$(getPath "archive_path")
                moveApplication "$production" "$staging" && moveApplication "$archive" "$production" && writeHistory 'Rolled back application'
                ;;
            3)
                displayVersionHistory
                ;;
            4)
                echo "Exiting application."
                continue_flag=false
                ;;
            *)
                echo "Invalid option. Please select a valid one."
                ;;
        esac
    done
}

# Start the application
runApp
