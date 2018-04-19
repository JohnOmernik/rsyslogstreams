#!/bin/bash

. ./env.list



if [ "$1" != "" ]; then
    echo "Argument to this script recieved, building with hacky fix - To build with original rsyslog omkafka plugin run ./build with no arguments"
    cp ./Dockerfile_hackfix ./Dockerfile
else
   echo "Building with _orig Docker file to build with the hacky fix, pass any argument to this script"
   cp ./Dockerfile_orig ./Dockerfile
fi


cp ./etc/rsyslog.conf.template ./etc/rsyslog.conf
sed -i "s/RSYSLOG_TCP_PORT/$RSYSLOG_TCP_PORT/g" ./etc/rsyslog.conf
sed -i "s/RSYSLOG_UDP_PORT/$RSYSLOG_UDP_PORT/g" ./etc/rsyslog.conf
sed -i "s/MAPR_CONTAINER_USER/$MAPR_CONTAINER_USER/g" ./etc/rsyslog.conf
sed -i "s/MAPR_CONTAINER_GROUP/$MAPR_CONTAINER_GROUP/g" ./etc/rsyslog.conf

cp ./etc/rsyslog.d/00-omkafka.conf.template ./etc/rsyslog.d/00-omkafka.conf

sed -i "s@MAPR_RSYSLOG_STREAM_LOCATION@$MAPR_RSYSLOG_STREAM_LOCATION@g" ./etc/rsyslog.d/00-omkafka.conf


sed -i "s/MAPR_RSYSLOG_TOPIC/$MAPR_RSYSLOG_TOPIC/g" ./etc/rsyslog.d/00-omkafka.conf


sudo docker build -t $IMG .

if [ "$?" == "0" ]; then
    echo "We'd push here"
#    sudo docker push $IMG
fi
