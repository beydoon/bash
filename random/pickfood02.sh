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

# initialize array and ask user for the choices
choices=()

# Ask user for a list of food
echo "List of food you would like to eat (double quote your choices)"
read -p "[E]nter choices: " userinput

IFS=$'"'
for value in ${userinput}; do
  echo "-> $value"
done

# Randomize the numbers upto $x
getFoodIndex=$(( RANDOM % ${#choices[@]} ))

# Let user know what to eat
echo "You should definately eat ${choices[getFoodIndex]} today!!!"