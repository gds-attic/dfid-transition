#!/bin/bash

#FUSEKI_URL=http://mirrors.muzzy.org.uk/apache/jena/binaries/jena-fuseki1-1.4.0-distribution.tar.gz
FUSEKI_URL=http://mirrors.muzzy.org.uk/apache/jena/binaries/apache-jena-fuseki-2.4.0.tar.gz
BASENAME=`basename ${FUSEKI_URL}`
VERSIONED_DIRNAME=`basename ${FUSEKI_URL} .tar.gz`
SERVER_LAUNCHER=${VERSIONED_DIRNAME}/fuseki-server

cd /usr/local
if [ ! -d /usr/local/fuseki ]; then
    sudo mkdir fuseki
fi

sudo chown `whoami` fuseki
sudo chmod 0755 fuseki

cd fuseki

TMP_ARCHIVE=/tmp/${BASENAME}

if [ ! -f /tmp/${BASENAME} ]; then
    curl ${FUSEKI_URL} > ${TMP_ARCHIVE}
fi

cp ${TMP_ARCHIVE} .
tar -xzf ${BASENAME}

# Fix for MacOS, which has $JAVA at /Library/Internet Plug-Ins (has a space)
sed -i.bak 's/exec $JAVA $JVM_ARGS/exec \"$JAVA\" $JVM_ARGS/' ${SERVER_LAUNCHER}


