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

### Copying all SQL Anywhere driver files to kafka-connect-jdbc folder and their dependencies
COPY drivers/jodbc4.jar drivers/sajdbc4.jar /usr/share/java/kafka-connect-jdbc
COPY library/* /usr/share/java/sql-anywhere-libs

## Added libs to SO PATH
ENV PATH=/usr/share/java/sql-anywhere-libs:${PATH}

RUN echo "===> Installing GCS Sink Connector ..."
RUN confluent-hub install confluentinc/kafka-connect-gcs:latest --no-prompt