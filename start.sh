#!/bin/bash

export LD_PRELOAD=/opt/mapr/lib/librdkafka.so


rsyslogd -dn
