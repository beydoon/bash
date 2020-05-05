#!/usr/bin/env bash
# set -x

input="$1"
inputlength=${#input}
counter=0

sumofall=0

while [ $inputlength -gt $counter ]; do
	value=${input:$counter:1}
	displayVC() {
		echo "VALUE TO TEST: $value"
		echo "COUNTER @    : $counter"
	}

	if (( "$counter" % 2 )); then
		echo "ODD x1:"
		displayVC
		yvalue=$(( $value * 2 ))
		echo "$value x 2 = $yvalue"
		if [ "$yvalue" -ge 10 ]; then
			totalvalue=$(( ${yvalue:0:1} + ${yvalue:1:1} ))
			echo "${yvalue:0:1} + ${yvalue:1:1} = $totalvalue"
			echo "$sumofall + $totalvalue"
			sumofall=$(( $sumofall + $totalvalue ))
			echo "sumofall = $sumofall"
		else
			echo "$sumofall + $yvalue"
			sumofall=$(( $sumofall + $yvalue ))
			echo "sumofall = $sumofall"
		fi
	else
		echo "EVEN x2:"
		displayVC
		xvalue=$(( $value * 1 ))
		echo "$value x 1 = $xvalue"
		echo "$sumofall + $xvalue"
		sumofall=$(( sumofall + $xvalue ))
		echo "sumofall = $sumofall"
	fi
	counter=$(( counter + 1 ))
	echo "COUNTER + 1 = $counter"
	echo ""
done

if (( "$sumofall" % 10 )); then
	echo "SIN: $input is INVALID"
else
	echo "SIN: $input is VALID"
fi
