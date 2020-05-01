#!/usr/bin/env bash
# runwhile.sh
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200428
# set -x

file="somefictiousfile"
seconds=10
list_rc=""

list() {
	ls $file >/dev/null 2>&1
	list_rc=$?
	if [ "$list_rc" = 0 ]; then
		echo "File FOUND!"
		list_rc=0
	else
		echo "File still not found!"
		list_rc=1
	fi
}

main() {
	list
	while [[ "$list_rc" = 1 ]]; do
		echo "The file does not exist yet"
		echo "going to try again in 10 seconds"
		sleep $seconds
		list
	done
}

main
