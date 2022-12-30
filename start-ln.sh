#!/bin/sh

# restart tor if hang up
#sudo service tor --full-restart

#lightningd --encrypted-hsm --daemon --log-file /var/log/lightning/lightning-filtered-debug.log --log-level=debug:channeld
lightningd --encrypted-hsm --daemon --log-file /var/log/lightning/lightning.log --plugin=/home/borsche/plugins/circular --circular-peer-refresh=600 --database-upgrade=true
#lightningd --encrypted-hsm --daemon --log-file /var/log/lightning/lightning.log

