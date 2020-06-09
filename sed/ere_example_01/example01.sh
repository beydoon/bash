#!/usr/bin/env bash

basedir="$(pwd)"
file1="$basedir/file1.log"
file2="$basedir/file2.log"

sed -E 's/^(.{11})49/\158/' $file1
