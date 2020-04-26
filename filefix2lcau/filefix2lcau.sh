#!/usr/bin/env bash
# filefix2lcau
# (file fix to lower-case and underscore)
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200426

# WARNING!! use this as long as you know what you are doing. This will alter
# the file names immediately as you run it


for oldname in *
do
	# convert oldname to lower-case
	lowercasename="$(echo ${oldname,,})"

	# replace space's with underscore
	newname="$(echo ${lowercasename// /_})"

	# print out the result
	printf "OLD NAME :\t%s\nNEW NAME :\t%s\n\n" "$oldname" "$replacespace"

	# rename the file name
	mv "$oldname" "$replacespace"
done
