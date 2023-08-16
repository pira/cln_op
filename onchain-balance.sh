#!/bin/bash

# Just parses listfunds output to display available onchain balance"
#
funds_msat=`lightning-cli listfunds | jq '.outputs[] | select (.reserved == false) | select(.status == "confirmed") | .amount_msat' | awk '{s+=$1} END {printf "%.0f",s}'`
funds=`echo $((funds_msat / 1000)) | numfmt --g`

echo $funds "sats"
