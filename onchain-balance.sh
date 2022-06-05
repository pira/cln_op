#!/bin/bash

# Just parses listfunds output to display available onchain balance"
#
funds=`lightning-cli listfunds | grep "value" | sed 's/      "value": //g' | sed 's/,//g' | awk '{s+=$1} END {print s}' | numfmt --g`
echo $funds "sats"
