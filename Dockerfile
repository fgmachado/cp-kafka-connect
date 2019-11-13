FROM confluentinc/cp-kafka-connect-base

MAINTAINER fgmachado0@gmail.com
ARG COMMIT_ID=unknown
ARG BUILD_NUMBER=-1

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
    && echo "===> Cleaning up ..."  \
    && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

COPY drivers/jconn4-7.07_SP133.jar /usr/share/java/kafka-connect-jdbc
COPY drivers/jtds-1.3.1-embratec.jar /usr/share/java/kafka-connect-jdbc
RUN rm /usr/share/java/kafka-connect-jdbc/jtds-1.3.1.jar

RUN echo "===> Installing GCS Sink Connector ..."
RUN confluent-hub install confluentinc/kafka-connect-gcs:latest --no-prompt