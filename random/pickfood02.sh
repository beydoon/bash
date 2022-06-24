#!/usr/bin/env bash
# pickfood02.sh
# Bash $RANDOM Example
# version 1.0.0
# Bedouin Technologies (c) Copyright 2022 *GPL*
# 20220610
# set -x

# In this example: 
#   - choices are put in array
#   - get the total number of choices and randomize it
#   - display the results

# set initial variables
answer="yes"
count=0

# Enter list of food or resturants you would like to eat or go to
IFS=$'\n'
while [ "${answer,,}" == "y" ] || [ "${answer,,}" == "yes" ]; do
  read -p "[E]nter food or resturant: " input
  options+=("$input")
  echo ""
  read -p "[E]nter another option? [y|n] " answer
done

# Show what you entered
for x in ${options[@]}; do
  ((++count))
  printf "[%s] YOU ENTERED -> %s\n" "$count" "$x"
done

# Randomize the food choice to pick
getRandomFoodIndex=$(( RANDOM % ${#options[@]} ))

# Let user know what to eat
printf "You should definately eat \"%s\" today.\n" "$(echo ${options[getRandomFoodIndex]})"