#!/bin/sh

# Compares current suez output to previous run
# Obviously needs suez: https://github.com/prusnak/suez
#
SUEZ_DIR="$HOME/suez"
STATUS_DIR='statuses'
stamp=`date '+%Y-%m-%d-%H%M%S'`

cd $SUEZ_DIR
/usr/bin/poetry run ./suez --show-chan-ids --client=c-lightning | awk 'BEGIN { FPAT = "([[:space:]]*[[:alnum:][:punct:][:digit:]]+)"; OFS = ""; } { $6=$7=$8=$9="";  print $0; }' >temp.status

if [ -d $STATUS_DIR ];
then
	prev_status=`readlink -f $STATUS_DIR/latest.status`
	if [ -f $prev_status ];
	then
		echo "Comparing current to $prev_status"
		sort -k 7 temp.status >/tmp/suez.status.1
		sort -k 7 $prev_status >/tmp/suez.status.2
		result=`diff -U 0 /tmp/suez.status.2 /tmp/suez.status.1`
		echo "$result"
	else
		echo "Empty $STATUS_DIR, will populate"
	fi
else
	echo "Creating $STATUS_DIR"
	mkdir -p $STATUS_DIR
fi

echo "Creating $STATUS_DIR/$stamp.status"
mv temp.status $STATUS_DIR/$stamp.status
ln -fs ./$stamp.status $STATUS_DIR/latest.status

echo "All done."
