FROM maprtech/pacc:6.0.1_5.0.0_ubuntu16

# Versions being run
ENV MAPR_LIBRDKAFKA_BASE="http://package.mapr.com/releases/MEP/MEP-5.0/ubuntu"
ENV MAPR_LIBRDKAFKA_FILE="mapr-librdkafka_0.11.3.201803231414_all.deb"
ENV RSYSLOG_VER="v8.34.0"


# A Shotgun approach to setting all the potential variabls to ensure MapR librdkafka gets used in compiling
ENV CFLAGS="-I=/opt/mapr/include -L=/opt/mapr/lib"
ENV LDFLAGS="-I=/opt/mapr/include -L=/opt/mapr/lib"
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH=/opt/mapr/lib:\$JAVA_HOME/jre/lib/amd64/server
ENV LD_RUN_PATH=/opt/mapr/lib
ENV LIBRARY_PATH=/opt/mapr/lib
ENV LIBRDKAFKA_CFLAGS=-I=/opt/mapr/include
ENV LIBRDKAFKA_LIBS=/opt/mapr/lib
RUN echo "/opt/mapr/lib" > /etc/ld.so.conf.d/mapr.conf && echo "/opt/mapr/lib/rsyslog" >> /etc/ld.so.conf.d/mapr.conf && echo "$JAVA_HOME/jre/lib/amd64/server" >> /etc/ld.so.conf.d/mapr.conf


# Install a bunch of tools fo compiling
RUN apt-get update && apt-get install -y \
              nano \
              vim \
              git \
              autoconf \
              libtool \
              libz-dev \
              libsasl2-dev \
              liblz4-dev \
              libjson0-dev \
              libssl-dev \
              libgcrypt-dev \
              libestr-dev \
              libcurl3-dev \
              flex \
              bison \
              pkg-config \
              python-docutils \
         && rm -rf /var/lib/apt/lists/*

# Install MapR LibRD KAfka - Have to unpack it and manually install it into the PACC
RUN MYPWD=`pwd` && wget ${MAPR_LIBRDKAFKA_BASE}/${MAPR_LIBRDKAFKA_FILE} && dpkg -x ${MAPR_LIBRDKAFKA_FILE} ./tmp  && \
    mkdir /opt/mapr/include/librdkafka && cp ./tmp/opt//mapr/include/librdkafka/* /opt/mapr/include/librdkafka/ && \
    cp ./tmp/opt/mapr/lib/librdkafka.so.1 /opt/mapr/lib/ &&  cd /opt/mapr/lib && ln -s librdkafka.so.1 librdkafka.so && ln -s librdkafka.so.1 librdkafka.a &&  ln -s libMapRClient.so libMapRClient_c.so && cd $MYPWD && \
    rm -rf ./tmp && rm ./${MAPR_LIBRDKAFKA_FILE} && ldconfig


# install libfastjson - SImple straight forward install
RUN  git clone https://github.com/rsyslog/libfastjson /tmp/libfastjson && cd /tmp/libfastjson && sh autogen.sh && ./configure && make && make install && cd .. 


# show library search path
#RUN ldconfig -v 2>/dev/null | grep -v ^$'\t'
#                                 --enable-kafka-static \


# This following line can be added to skip a check for brokers. This allows us to push data to a single partition, but does not solve our problem


RUN echo "Pulling rsyslog" && git clone https://github.com/rsyslog/rsyslog /tmp/rsyslog && cd /tmp/rsyslog && git checkout -b "$RSYSLOG_VER" refs/tags/$RSYSLOG_VER            \
                    && sed -i '957i*/' ./plugins/omkafka/omkafka.c && sed -i '951i/*' ./plugins/omkafka/omkafka.c  && cat ./plugins/omkafka/omkafka.c \ 
                    && ./autogen.sh --enable-omkafka \
                                 --disable-uuid \
                                 --disable-liblogging_stdlog \
                                 --disable-generate-man-pages \
                                 --prefix=/usr \
                                 --libdir=/opt/mapr/lib \
                                 --includedir=/opt/mapr/include \
                    && make \
                    && make install && ldconfig


ADD etc/rsyslog.conf /etc/rsyslog.conf
ADD etc/rsyslog.d/00-omkafka.conf /etc/rsyslog.d/00-omkafka.conf

# Permissions things because rsyslog is not run as root 
RUN mkdir -p /opt/rsyslog && chmod -R 777 /opt/rsyslog  && chmod 666 /etc/rsyslog.conf && chmod -R 777 /etc/rsyslog.d  && chmod -R 777 /run

ADD start.sh /opt/rsyslog/start.sh

RUN chmod +x /opt/rsyslog/start.sh

#ENV LD_PRELOAD=/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so
