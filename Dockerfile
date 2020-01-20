FROM confluentinc/cp-kafka-connect-base
ENV COMPONENT=kafka-connect

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN echo "===> Installing JDBC, Elasticsearch and Hadoop connectors ..." \
    && apt-get -qq update \
    && apt-get install -y \
        confluent-kafka-connect-jdbc=${CONFLUENT_VERSION}${CONFLUENT_PLATFORM_LABEL}-${CONFLUENT_DEB_VERSION} \
        confluent-kafka-connect-elasticsearch=${CONFLUENT_VERSION}${CONFLUENT_PLATFORM_LABEL}-${CONFLUENT_DEB_VERSION} \
        confluent-kafka-connect-storage-common=${CONFLUENT_VERSION}${CONFLUENT_PLATFORM_LABEL}-${CONFLUENT_DEB_VERSION} \
        confluent-kafka-connect-s3=${CONFLUENT_VERSION}${CONFLUENT_PLATFORM_LABEL}-${CONFLUENT_DEB_VERSION} \
        confluent-kafka-connect-jms=${CONFLUENT_VERSION}${CONFLUENT_PLATFORM_LABEL}-${CONFLUENT_DEB_VERSION} \
        libavro-c1 \  
        libavro-cpp1 \ 
        libavro-c-dev \ 
        libavro-cpp-dev \
    && echo "===> Cleaning up ..."  \
    && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

COPY drivers/mysql-connector-java-8.0.18.jar /usr/share/java/kafka-connect-jdbc
COPY drivers/jconn4-7.07_SP133.jar /usr/share/java/kafka-connect-jdbc
COPY drivers/jtds-1.3.1-embratec.jar /usr/share/java/kafka-connect-jdbc