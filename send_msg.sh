#!/bin/bash
. ./env.list
echo "Sending Messgage"
echo '<14>This is a message to our MapR Streams rsyslog' | ncat -w 1 -u $(hostname) $RSYSLOG_UDP_PORT
