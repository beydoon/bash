#!/usr/bin/env bash
# sinval
# This script validates canadian social insurance number
# version 1.0.4
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200503
#set -x

usersin="$1"
counter=0
finalsum=0

usage() {
	cat <<EOF
Usage: $0 nnnnnnnnn

	Provide a total of 9 numbers without spaces or dashs; n represents number as example.
EOF
exit 1
}

validateinput() {
	value=$1

	if [[ $value < 9 ]]; then
		usage
	fi
}

printResult() {
	fmt="%s SIN: %s"
	sinfmt="${usersin:0:3}-${usersin:3:3}-${usersin:6:3}" 

	if [ "${1,,}" == "valid" ]; then
		printf "$fmt\n" "VALID" "$sinfmt" 
	fi

	if [ "${1,,}" == "invalid" ]; then
		printf "$fmt\n" "INVALID" "$sinfmt" 
	fi
}

validate() {
	value="$1"

	if (( "$finalsum" % 10 )); then
		printResult "INVALID"
	else
		printResult "VALID"
	fi
}

calculate() {
	value="$1"

	if (( "$value" >= 10 )); then
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
	validateinput "$sinTotalLength"

	while [ "$sinTotalLength" -gt "$counter" ]; do
		value=${usersin:$counter:1}

		if (( "$counter" % 2 )); then
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
