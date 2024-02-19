#!/bin/bash

#Setting debug mode
if [[ "$1" == "debug" || "$1" == "Debug" ]]; then
    set -x
    echo "debug mode is on"
else
    echo "normal mode is on"
fi

echo "Starting..."

# Colors for displaying user input
blue="\033[0;36m"
green="\033[1;32m"
yellow="\033[1;33m"
reset="\033[0m"
title="Ubuntu Deployment Manager"
one="Promote Application"
two="Rollback Application"
three="Display Application Version History"
four="EXIT"
options=("Promote Application" "Rollback Application" "Display Application Version History" "EXIT")

# Function to display user options
function displayUserOptions() {    
    echo -e "${blue}==============================================================${RESET}"
    echo -e "${blue}|${reset}      ${green}${title}${reset}       "
    echo -e "${blue}==============================================================${reset}"
    for ((i=0; i<${#options[@]}; i++)); do
        echo -e "${blue}|${reset} $((i+1)). ${yellow}${options[i]}${reset}"
    done
    echo -e "${blue}==============================================================${reset}"
    echo -e "${blue}|${reset} Please select an option (1-${#options[@]}):"
    echo -e "${blue}==============================================================${reset}"
}

# Function to capture user option
function captureUserOption() {
    read -r user_option_input
    echo "${user_option_input}"
}

# Function to handle promoting application
function promoteApplication(){
    local staging production
    staging=$(getPath "staging_path")
    production=$(getPath "production_path")
    # missing logic
}

# Function to handle moving the application
function moveApplication() {     
    local source_dir="$1"
    local destination_dir="$2"
    local user_response

    # Check if the source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Source directory $source_dir does not exist!"
        return 1
    fi

    # Check if the destination directory exists
    if [ ! -d "$destination_dir" ]; then
        echo "Destination directory $destination_dir does not exist!"
        return 1
    fi

    # Check if the current user has write permission on the destination directory
    if [ ! -w "$destination_dir" ]; then
        echo "You do not have permission to move the directory $source_dir to the protected folder $destination_dir."
        echo "Would you like to change the permission of the $destination_dir?"        
        echo "Enter your response (y/n): "
        user_response=$(captureUserOption)    

        if [ "$user_response" == "y" ]; then
            sudo chmod +w "$destination_dir" 
        else            
            echo "You have said no, therefore we will not continue!"
            return 1
        fi     
            
    fi

    echo "You have permission to move the directory to the protected folder."
    
    # Perform the move operation here
    if ! sudo mv "$source_dir" "$destination_dir"; then
        echo "Failed to move $source_dir to $destination_dir."
        return 1
    fi

    echo "Successfully moved $source_dir to $destination_dir."
}

# Function to handle displaying application version history
function displayVersionHistory() {
    pathDefinition
    echo -e "${blue}==============================================================${reset}"
    echo -e "${blue}|${reset} Application Version History"
    echo -e "${blue}==============================================================${reset}"
    cat ./path.txt  
}

# Function to write action history to file
function writeHistory() {
    local action_message="$1"
    local writeDate
    writeDate=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$writeDate: $action_message" >> ./path.txt
}

# Function to define paths
function pathDefinition() {
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
function validatePath() {
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

#Function to support validate and write paths
function getPath(){
    local path_key="$1"
    echo "$(grep "$path_key" "./path.txt" | cut -d "=" -f 2)"
}

# Function to run the application
function runApp() {
    local continue_flag='true'
    while [ "$continue_flag" != 'false' ]; do
        displayUserOptions
        local user_selected_option
        user_selected_option=$(captureUserOption)
        case $user_selected_option in
            *[!0-9]*|'') echo "Please enter a valid number." ;;
            *)
                if ((user_selected_option >= 1 && user_selected_option <= ${#options[@]})); then
                    echo "User selected option $user_selected_option."
                    case $user_selected_option in
                        1)
                            pathDefinition
                            local staging production archive
                            staging=$(getPath "staging_path")
                            production=$(getPath "production_path")
                            archive=$(getPath "archive_path")
                            moveApplication "$production" "$archive" || echo "Production to archive operation failed."
                            moveApplication "$staging" "$production" || echo "Staging to production operation failed."
                            writeHistory 'promote application'
                            ;;
                        2)
                            pathDefinition
                            local staging production archive
                            staging=$(getPath "staging_path")
                            production=$(getPath "production_path")
                            archive=$(getPath "archive_path")
                            moveApplication "$production" "$staging" || echo "Production to staging operation failed."
                            moveApplication "$archive" "$production" || echo "Archive to production operation failed."
                            writeHistory 'rollback application'
                            ;;
                        3)
                            echo "User selected option 3."
                            displayVersionHistory
                            ;;
                        4)
                            echo "Exiting application"
                            continue_flag='false'
                            ;;
                    esac
                else
                    echo "Please select from the listed options"
                fi
                ;;
        esac
    done
}

# Start the application
runApp
