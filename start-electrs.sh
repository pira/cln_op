#!/bin/sh

nohup electrs --daemon-rpc-addr 127.0.0.1:8899 --log-filters INFO >/var/log/lightning/electrs.log &


