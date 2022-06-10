#!/usr/bin/env bash
# pickfood01.sh
# Bash $RANDOM Example
# version 1.0.0
# Bedouin Technologies (c) Copyright 2022 *GPL*
# 20220610
# set -x

# This example will take results from your input and randomly tell you what you
# should eat today

# initialize array
choices=()

# ask user for the choices
read -p "[E]nter choices delimited by spaces: " choices

# get total number of choices
x=${#choices[@]}

# Randomize the numbers upto $x
y=$(( RANDOM % $x ))

# Let user know what to eat
echo "You should ${choice[$y] today!"