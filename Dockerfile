FROM ubuntu:18.04
MAINTAINER quarrier <quarriermarje@gmail.com>
COPY ./pdi-ce-9.0.0.0-423.zip /data-integration/
ADD ./jdk /usr/local/openjdk-8
ENV JAVA_HOME /usr/local/openjdk-8
ENV SERVER_PORT 8081
ENV SERVER_HOST 0.0.0.0
ENV JAVA_BIN=$JAVA_HOME/bin \
    JRE_HOME=$JAVA_HOME/jre \
	CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
	PENTAHO_JAVA_HOME=$JAVA_HOME \
	_PENTAHO_JAVA_HOME=$JAVA_HOME \
	PENTAHO_HOME=/data-integration \
	KETTLE_HOME=/data-integration
ENV PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
	
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
echo 'deb http://mirrors.huaweicloud.com/ubuntu/ bionic main restricted universe multiverse'> /etc/apt/sources.list && \
echo 'deb http://mirrors.huaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.huaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.huaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.huaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.huaweicloud.com/ubuntu/ bionic main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.huaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.huaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.huaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.huaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse'>> /etc/apt/sources.list && \
echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse'>> /etc/apt/sources.list

RUN apt-get update && apt-get -y install libwebkitgtk-1.0-0 vim ca-certificates openssl zip locales language-pack-zh-hans tzdata \
	&& rm -rf /var/lib/apt/lists/* \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
	&& echo "Asia/Shanghai" > /etc/timezone \
	&& rm -f /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata
	
ENV LANG zh_CN.UTF-8

WORKDIR $KETTLE_HOME
ADD docker-entrypoint.sh $KETTLE_HOME/docker-entrypoint.sh

RUN unzip ./pdi-ce-9.0.0.0-423.zip -d $KETTLE_HOME/ \
	&& mv ./data-integration/** ./ \
	&& rm -rf ./data-integration \
	&& rm -rf ./pdi-ce-9.0.0.0-423.zip \
	&& chmod -R 777 /data-integration \    
	&& chmod -R 777 /usr/local/openjdk-8

COPY ./mysql-connector-java-5.1.48-bin.jar $KETTLE_HOME/lib/

EXPOSE $SERVER_PORT

CMD ["/bin/bash","./docker-entrypoint.sh"]
