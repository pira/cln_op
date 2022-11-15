#!/bin/sh

# Compares current suez output to previous run
# Obviously needs suez: https://github.com/prusnak/suez
#
SUEZ_DIR="$HOME/suez"
STATUS_DIR='statuses'
stamp=`date '+%Y-%m-%d-%H%M%S'`

cd $SUEZ_DIR
python3 ./suez --show-chan-ids --client=c-lightning | grep '|' | tr -s ' ' | awk 'BEGIN { FPAT = "([[:space:]]*[[:alnum:][:punct:][:digit:]]+)"; } { printf "%16s [%13s <=> %-13s] f: %5s s: %8s ",$NF,$1,$3,$5,$9; } { $1=$2=$3=$4=$5=$6=$7=$8=$9=$NF=""; print $0}' | sort -k 1 >temp.status

# Compare two given status files and display result. Recent first
fn_compare() {
	#result=`diff -w -U 0 $2 $1`
	result=`comm -3 --output-delimiter='' $2 $1` 
	echo "$result" | sed '0~2 a\\'
}

if [ -d $STATUS_DIR ];
then
	prev_status=`readlink -f $STATUS_DIR/latest.status`
	if [ -f $prev_status ];
	then
		echo "Comparing current to $prev_status"
		fn_compare temp.status $prev_status
	else
		prev_status=$STATUS_DIR/`ls -1t $STATUS_DIR | head -1`
		if [ -f $prev_status ];
		then
			echo "latest.status missing, will compare to $prev_status"
			fn_compare temp.status $prev_status			
		else
			echo "Empty $STATUS_DIR, nothing to compare, will populate"
		fi
	fi
else
	echo "Creating $STATUS_DIR"
	mkdir -p $STATUS_DIR
fi

echo "Creating $STATUS_DIR/$stamp.status"
mv temp.status $STATUS_DIR/$stamp.status
ln -fs ./$stamp.status $STATUS_DIR/latest.status

echo "All done."
