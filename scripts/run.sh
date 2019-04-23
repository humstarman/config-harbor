#!/bin/bash
set -ex
FILE=restart-harbor
BIN=/usr/local/bin/${FILE}.sh
cat > ${BIN}<<"EOF"
#!/bin/bash
restart(){
COMPONENTS="nginx harbor-ui registry harbor-db harbor-adminserver redis harbor-log"
for COMPONENT in ${COMPONENTS}; do
  if docker ps --format {{.Names}} | grep $COMPONENT; then
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - ${COMPONENT} found, skip."
  else
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [WARN] - ${COMPONENT} not found! Restart!"
    docker restart $COMPONENT
  fi
done
sleep 3
}
restart
restart
restart
EOF
UNIT=/etc/systemd/system/${FILE}.service
cat > ${UNIT}<<EOF
[Unit]
Description=Check and Start Compontents of Harbor

[Service]
Type=oneshot
ExecStart=/bin/sh \
          -c \
          "sleep 60 && ${BIN}"

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable ${FILE}
systemctl restart ${FILE}
