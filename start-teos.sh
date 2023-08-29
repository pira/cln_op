#!/bin/sh

nohup /home/borsche/.cargo/bin/teosd >/var/log/lightning/teosd.log 2>&1 &

