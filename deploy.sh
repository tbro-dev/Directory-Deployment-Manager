#!/bin/bash

#vars
BLUE="\033[0;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
TITLE="Ubuntu Deployment Manger"
ONE="Promote Application"
TWO="Rollback Application"
THREE="Display Application Version History"
FOUR="EXIT"
user_option_input=""

#procedures
function pathDefinition(){

    # Path to the file you want to check
    file_path="./path.txt"
    file_exists=false

    # Check if the file exists
    if [ -f "$file_path" ]; then
        file_exists=true
    else
        file_exists=false
    fi

    # Print the result
    echo "File exists: $file_exists"

    if [$file_exists == true]; then


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
    echo -e "You responded with: ${user_option_input}"
}


if [ $user_option_input == 1 ]; then
    pathDefinition

case $user_option_input in
  1)
    echo "Count is 1."
    ;;
  2)
    echo "Count is 2."
    ;;
  3)
    echo "Count is not 1 or 2."
    ;;
  4)
    echo "Exiting application"
    ;;
esac

# Define a function with arguments
greet() {
    local name="$1"   # First argument
    local time="$2"   # Second argument

    echo "Hello, $name! Good $time."
}

greet "Alice" "morning"


testing() {
    local arg="$1";

    echo $arg
    

}

oneTime="true"