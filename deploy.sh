#!/bin/bash

if [[ "$1" == "debug" || "$1" == "Debug" ]]; then
    set -x
    echo "debug mode is on"
else
    echo "normal mode is on"
fi

echo "Starting..."

# Vars
BLUE="\033[0;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
TITLE="Ubuntu Deployment Manager"
ONE="Promote Application"
TWO="Rollback Application"
THREE="Display Application Version History"
FOUR="EXIT"

# Function to display user options
function displayUserOptions() {    
    
    echo -e "${BLUE}==============================================================${RESET}"
    echo -e "${BLUE}|${RESET}      ${GREEN}${TITLE}${RESET}       "
    echo -e "${BLUE}==============================================================${RESET}"
    echo -e "${BLUE}|${RESET} 1. ${YELLOW}${ONE}${RESET}                  "
    echo -e "${BLUE}|${RESET} 2. ${YELLOW}${TWO}${RESET}                  "
    echo -e "${BLUE}|${RESET} 3. ${YELLOW}${THREE}${RESET}                "
    echo -e "${BLUE}|${RESET} 4. ${YELLOW}${FOUR}${RESET}                 "
    echo -e "${BLUE}==============================================================${RESET}"
    echo -e "${BLUE}|${RESET} Please select option 1, 2, 3, or 4:         "
    echo -e "${BLUE}==============================================================${RESET}"
}

# Function to capture user option
function captureUserOption() {
    read user_option_input
    echo "${user_option_input}"
}

# Function to handle promoting application
function promoteApplication(){
    staging=$(getPath "staging_path")
    production=$(getPath "production_path")    
}

# Function to handle rolling back application
#function rollbackApplication() {
    # Your implementation
#}

# Function to handle displaying application version history
function displayVersionHistory() {
    pathDefinition
    echo -e "${BLUE}==============================================================${RESET}"
    echo -e "${BLUE}|${RESET} Application Version History"
    echo -e "${BLUE}==============================================================${RESET}"
    cat ./path.txt  
}

# Function to write action history to file
function writeHistory() {
    local action_message="$1"     
    writeDate=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$writeDate: $action_message" >> ./path.txt
}

# Function to define paths
function pathDefinition() {
    file_path="./path.txt"
     
    echo -e "${BLUE}==============================================================${RESET}"

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
        echo -e "${BLUE}==============================================================${RESET}"
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
    local pathKey="$1"                  
    local pathTitle="${pathKey//_/ }"   
     
    echo -e "${BLUE}==============================================================${RESET}"
    
    if grep -q "$pathKey" "./path.txt"; then
        key_contents=$(getPath $pathKey)
        echo "${pathTitle}: ${key_contents}"       
        

    else
        read -p "Enter $pathTitle: " user_res
        echo "$pathKey=$user_res" >> ./path.txt
    fi
}

#Function to support validate and write paths
function getPath(){
    local pathKey="$1"
    local pathTitle="${pathKey//_/ }"
    echo $(grep "$pathKey" "./path.txt" | cut -d "=" -f 2)
}

# Function to run the application
function runApp() {
continue='true'
while [ $continue != 'false' ]; do
    displayUserOptions
    user_selected_option=$(captureUserOption)
    case $user_selected_option in
        1)
            echo "User selected option 1."
            pathDefinition
            promoteApplication
            writeHistory 'promote application'
            ;;
        2)
            echo "User selected option 2."
            pathDefinition
            writeHistory 'rollback application'
            ;;
        3)
            echo "User selected option 3."
            displayVersionHistory 
            ;;
        4)
            echo "Exiting application"
            continue='false'
            ;;
        *)
            echo "Please select from the listed options"
            ;;
        esac

    done
}

# Start the application
runApp
