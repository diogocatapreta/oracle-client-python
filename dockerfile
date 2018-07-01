FROM ubuntu:16.04

LABEL maintainer="Diogo Cata Preta"

ENV DEBIAN_FRONTEND noninteractive

ENV ORACLE_INSTANTCLIENT_MAJOR 11.2
ENV ORACLE_INSTANTCLIENT_VERSION 11.2.0.4.0
ENV ORACLE /usr/lib/oracle
ENV ORACLE_HOME $ORACLE/$ORACLE_INSTANTCLIENT_MAJOR/client64
ENV TNS_ADMIN=$ORACLE_HOME/network/admin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE_HOME/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$ORACLE/include/oracle/$ORACLE_INSTANTCLIENT_MAJOR/client64

RUN apt-get update && apt-get install -y libaio1 alien && mkdir $ORACLE

ADD $ORACLE_INSTANTCLIENT_MAJOR/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-basic-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm /tmp/
ADD $ORACLE_INSTANTCLIENT_MAJOR/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-sqlplus-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm /tmp/
ADD $ORACLE_INSTANTCLIENT_MAJOR/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-devel-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm /tmp/

RUN    alien -iv /tmp/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-basic-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm \
    && alien -iv /tmp/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-sqlplus-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm \
    && alien -iv /tmp/oracle-instantclient$ORACLE_INSTANTCLIENT_MAJOR-devel-$ORACLE_INSTANTCLIENT_VERSION-1.x86_64.rpm \
    && ldconfig \
    && ln -snf $ORACLE/$ORACLE_INSTANTCLIENT_MAJOR/client64 /opt/oracle \
    && mkdir -p $ORACLE_HOME/network/admin \
    && ln -snf /etc/oracle $ORACLE_HOME/network/admin \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && apt-get purge -y --auto-remove 