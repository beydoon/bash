#!/usr/bin/env bash
# sinval
# This script validates canadian social insurance number
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200503
#set -x

usersin="$1"
counter=0
finalsum=0

printResult() {
	fmt="%s is %s."

	if [ "$1" == valid ]; then
		printf "$fmt\n" "$usersin" "valid"
	fi

	if [ "$1" == invalid ]; then
		printf "$fmt\n" "$usersin" "invalid"
	fi
}

validate() {
	value="$1"

	if (( $finalsum % 10 )); then
		printResult "invalid"
	else
		printResult "valid"
	fi
}

calculate() {
	value="$1"

	if (( $value >= 10 )); then
		val1=${value:0:1}
		val2=${value:1:1}
		total=$(( $val1 + $val2 ))
		finalsum=$(( finalsum + $total ))
	else
		finalsum=$(( finalsum + $value ))
	fi
}

main() {
	sinTotalLength=${#usersin}

	while [ $sinTotalLength -gt $counter ]; do
		value=${usersin:$counter:1}

		if (( $counter % 2 )); then
			y="$(( $value * 2 ))"
			calculate "$y"
		else
			x="$(( $value * 1 ))"
			calculate "$x"
		fi
		counter=$(( counter+1 ))
	done
	validate "$finalsum"
}

main
