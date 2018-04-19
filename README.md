# omkafka on MapR Stream

- Original git: https://github.com/tcnksm-sample/omkafka

Steps
- First copy env.list.template to env.list
- Open env.list and put in your information for things
- run mkstream.sh to call maprcli to make the stream for this test
- run build.sh to build the docker container
  - Note: ./build.sh (no arguments) builds with the rsyslog plugin exactly as it is in the rsyslog repo
  - running ./build.sh 1 (or with any argument) comments out a line of code in the omkafka.c file that checks for brokers. It's still broker, but it will put data into the first partition only. 
- run ./run.sh to start the container. When the container is started run /opt/rsyslog/start.sh to start rsyslogd in debug mode. 
- Open another shell and run ./send_msg.sh to send a message to the kafka broker. 

