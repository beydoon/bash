#!/usr/bin/env bash
# braceExpansionDemo
# Brace Expansion Demo
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200513
#set -x

string1="the quick red fox"
string2="THE ELEPHANT IN THE ROOM"

# Echo string1 all upper-case
echo ${string1^^}

# Echo string2 all lower-case
echo ${string2,,}

# Echo string1 start with first charecter capitalized
echo ${string1^}
