#!/bin/bash

COMPONENTS="nginx harbor-ui registry harbor-db harbor-adminserver redis harbor-log"
for COMPONENT in ${COMPONENTS}; do
  if docker ps --format {{.Names}} | grep $COMPONENT; then
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - ${COMPONENT} found, skip."
  else
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [WARN] - ${COMPONENT} not found! Restart!"
    docker restart $COMPONENT
  fi
done
