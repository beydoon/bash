#!/usr/bin/env bash
# Return value in variable
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200427
# set -x

value1="$1"
value2="$2"

abs() {
	if [ "$1" -ge 0 ]; then
		absval=$1
	else
		let "absval = (( 0 - $1 ))"
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
