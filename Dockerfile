FROM openjdk:8u252
MAINTAINER quarrier <quarriermarje@gmail.com>

COPY ./data-integration /data-integration

ENV EXPOSE_PORT 8081
ENV EXPOSE_IP 192.168.137.54
ENV JAVA_BIN=$JAVA_HOME/bin \
    JRE_HOME=$JAVA_HOME/jre \
	CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
	PENTAHO_JAVA_HOME=$JAVA_HOME \
	_PENTAHO_JAVA_HOME=$JAVA_HOME \
	PENTAHO_HOME=/data-integration \
	KETTLE_HOME=/data-integration
ENV PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

ADD docker-entrypoint.sh $KETTLE_HOME/docker-entrypoint.sh
RUN chmod 777 /data-integration \
    && chmod 777 /data-integration/**

EXPOSE $EXPOSE_PORT
WORKDIR $KETTLE_HOME

CMD ["/bin/bash","./docker-entrypoint.sh","master"]
