#!/usr/bin/env bash
# runwhile.sh
# version 1.0.0
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200513
# set -x

logfile="some.log"

# search enable and replace 0 with a 1
sed '/^enable/s/0/1' $logfile