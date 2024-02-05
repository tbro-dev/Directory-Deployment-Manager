#!/bin/bash

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


echo -e "${BLUE}==============================================================${RESET}"
echo -e "${BLUE}|${RESET}      ${GREEN}${TITLE}${RESET}       "
echo -e "${BLUE}==============================================================${RESET}"
echo -e "${BLUE}|${RESET} 1. ${YELLOW}${ONE}${RESET}                  "
echo -e "${BLUE}|${RESET} 2. ${YELLOW}${TWO}${RESET}                  "
echo -e "${BLUE}|${RESET} 3. ${YELLOW}${THREE}${RESET}                "
echo -e "${BLUE}|${RESET} 4. ${YELLOW}${FOUR}${RESET}                 "
echo -e "${BLUE}==============================================================${RESET}"
echo -e "${BLUE}|${RESET} Please select option 1, 2, 3, or 4:         "
read user_option_input
echo -e "${BLUE}==============================================================${RESET}"
echo -e "You responded with: ${user_option_input}"