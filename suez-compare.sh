#!/bin/sh

# Compares current suez output to previous run
# Obviously needs suez: https://github.com/prusnak/suez
#
SUEZ_DIR="$HOME/suez"
STATUS_DIR='statuses'
TEMP_STATUS='curr.status'
stamp=`date '+%Y-%m-%d-%H%M%S'`

cd $SUEZ_DIR
/usr/bin/poetry run ./suez --show-chan-ids --client=c-lightning | awk 'BEGIN { FPAT = "([[:space:]]*[[:alnum:][:punct:][:digit:]]+)"; OFS = ""; } { $6=$7=$8=$9="";  print $0; }' >$TEMP_STATUS

if [ -d $STATUS_DIR ];
then
	prev_status=`ls -1t $STATUS_DIR | head -1`
	echo "Comparing current to $prev_status"
	sort -k 7 $TEMP_STATUS >/tmp/suez.status.1
	sort -k 7 $STATUS_DIR/$prev_status >/tmp/suez.status.2
	result=`diff -U 0 /tmp/suez.status.2 /tmp/suez.status.1`
	echo "$result"
else
	echo "Creating $STATUS_DIR"
	mkdir $STATUS_DIR
fi

echo "Creating $STATUS_DIR/$stamp.status"
mv $TEMP_STATUS $STATUS_DIR/$stamp.status

echo "All done."
