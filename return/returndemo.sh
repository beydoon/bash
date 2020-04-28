#!/usr/bin/env bash
# Return value in variable
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200427
# set -x

value1="$1"
value2="$2"

# This function uses exit status, which is fine until 255 then hell breaks
# lose! Exit codes start from 0 to 255. So i've made another approach to this.
# I've used sed to just simply take the negative symbol out and return the
# value as an absolute.

#abs() {
#	if [ "$1" -ge 0 ]; then
#		absval=$1
#	else
#		let "absval = (( 0 - $1 ))"
#	fi
#
#	return $absval
#}


abs() {
	if [ "$1" -ge 0 ]; then
		absval=$1
	else
		absval="$( echo $1 | sed 's/-//' )"
	fi

	return $absval
}

main() {
	calculate="$(echo "$value1 - $value2" | bc)"
	abs $calculate
	output=$?

	echo $output
}

main
