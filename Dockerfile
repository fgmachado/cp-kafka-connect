FROM confluentinc/cp-kafka-connect-base

MAINTAINER fgmachado0@gmail.com
LABEL io.confluent.docker=true
ARG COMMIT_ID=unknown
LABEL io.confluent.docker.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL io.confluent.docker.build.number=$BUILD_NUMBER

ENV COMPONENT=kafka-connect

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
COPY drivers/* /usr/share/java/kafka-connect-jdbc
COPY library/* /usr/share/java/sql-anywhere-libs

## Added libs to SO PATH
ENV PATH=/usr/share/java/sql-anywhere-libs:${PATH}

RUN echo "===> Installing GCS Sink Connector ..."
RUN confluent-hub install confluentinc/kafka-connect-gcs:latest --no-prompt