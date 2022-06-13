#!/usr/bin/env bash
# pickfood01.sh
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
choices=("Beef Burger" "Chicken Burger" "French Fries" "Chicken Nuggets" "Fish burger")

# Randomize the numbers upto $x
getFoodIndex=$(( RANDOM % ${#choices[@]} ))

# Let user know what to eat
echo "You should definately eat ${choices[getFoodIndex]} today!!!"