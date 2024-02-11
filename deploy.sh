#!/bin/bash
set -x
echo "Starting..."
# Your script here

#vars
################################################
BLUE="\033[0;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
TITLE="Ubuntu Deployment Manager"
ONE="Promote Application"
TWO="Rollback Application"
THREE="Display Application Version History"
FOUR="EXIT"
user_option_input=""

#procedures
#################################################
function validatePath(){
        
        local pathKey="$1"                  # First argument, example staging_path
        local pathTitle="${pathKey//_/ }"   # Second argument, example staging path

    # Check if the pathKey exists in path.txt
        if grep -q "$pathKey" "path.txt"; then
            staging_path=$(grep "$pathKey" "path.txt" | cut -d "=" -f 2)
        else
            read -p "Enter $pathTitle: " user_res
            echo "$pathKey=$user_res" >> path.txt
        fi
}

function pathDefinition(){

    # Path to the file you want to check
    file_path="./path.txt"
  
    # Check if the file exists
    if [ -f "$file_path" ]; then
        file_exists=true
    else
        file_exists=false
    fi

    # Print the result
    echo "File exists: $file_exists"

    if [ $file_exists == true ]; then
    
        echo "the file path.txt exists"
        
        validatePath "staging_path"
        validatePath "production_path"
        validatePath "archive_path"
    else     

    echo "The file was not available, lets create one to support the application"
    read -p "Enter the path for the staging folder: " staging_path
    read -p "Enter the path for the production folder: " production_path
    read -p "Enter the path for the archive folder: " archive_path

    echo "staging_path=$staging_path" > path.txt
    echo "production_path=$production_path" > path.txt
    echo "archive_path=$archive_path" > path.txt

    fi

    echo "You have listed the paths below:"
    echo "Staging: $staging_path"
    echo "Production: $production_path"
    echo "Archive: $archive_path_path"

}

function displayUserOptions(){

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

function captureUserOption(){
    read user_option_input
    echo "${user_option_input}"
}


#start application
displayUserOptions
user_selected_option=$(captureUserOption)
    

case $user_selected_option in
1)
    pathDefinition
    echo "User selected option 1."
    displayUserOptions
    ;;
2)
    pathDefinition
    echo "User selected option 2."
    displayUserOptions
    ;;
3)
    pathDefinition
    echo "User selected option 3."
    displayUserOptions
    ;;
4)
    echo "Exiting application"
    ;;
*)

    echo "Please select from the listed options"
    displayUserOptions
    ;;
esac
