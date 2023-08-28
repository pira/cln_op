SUEZ_DIR="$HOME/suez"
STATUS_DIR='statuses'

cd $SUEZ_DIR
if [ -d $STATUS_DIR ];
then
	last_status=`readlink -f $STATUS_DIR/latest.status`
	if [ -f $last_status ];
	then
		rm $last_status
		rm $STATUS_DIR/latest.status
		echo "Cleaned up last symlink and $last_status"
	fi
else
	echo "No $SUEZ_DIR/$STATUS_DIR found, nothin to cleanup"
fi
