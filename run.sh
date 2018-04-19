#!/bin/bash

. ./env.list

PORTS="-p ${RSYSLOG_UDP_PORT}:${RSYSLOG_UDP_PORT}/udp -p ${RSYSLOG_TCP_PORT}:${RSYSLOG_TCP_PORT}/tcp"

echo "To start rsyslog please run the following command"
echo ""
echo "/opt/rsyslog/start.sh"
echo ""

sudo docker run -it $PORTS --env-file ./env.list -v=/tmp/mapr_ticket:/tmp/mapr_ticket:ro \
   --device /dev/fuse \
   --security-opt apparmor:unconfined \
   $IMG /bin/bash
