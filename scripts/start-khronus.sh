#!/bin/bash

function waitFor {
	host=$1
	port=$2
	while ! nc -z $host $port 2>/dev/null
	do
	  echo -n .
	  sleep 1
	done	
}

CREDENTIALS='YWRtaW46YWRtaW4=' #RFC 2045 base64 encoding -> printf admin:admin | base64

function post {
	host=$1
	port=$2
	url=$3
	content=$4
	content_length=$(echo -n "$content" | wc -c)
	echo -ne "POST $url HTTP/1.1\r\nHost: $host\r\nAuthorization: Basic $CREDENTIALS\r\nContent-Type: application/json;charset=UTF-8\r\nContent-Length: $content_length\r\n\r\n$content" | nc -i 3 $host $port
}

cd /usr/share/grafana && nohup /usr/share/grafana/bin/grafana-server --config=/etc/grafana/grafana.ini cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana &

GRAFANA_HOST='localhost'
GRAFANA_PORT=3000
waitFor "$GRAFANA_HOST" "$GRAFANA_PORT"

myIp=$(hostname -i)
DATASOURCE_PAYLOAD='{"name":"khronus","type":"influxdb_08","isDefault": true,"url":"http://localhost:8400/khronus","access":"direct","database":"influx","user":"test","password":"test"}'
DATASOURCE_PAYLOAD_LEN=$(echo -n ${DATASOURCE_PAYLOAD} | wc -c)

post "$GRAFANA_HOST" "$GRAFANA_PORT" '/api/datasources' "$DATASOURCE_PAYLOAD"

post "$GRAFANA_HOST" "$GRAFANA_PORT" '/api/dashboards/db/' "`cat /opt/khronus/khronus-dashboard.json`"

waitFor $CASSANDRA_PORT_9042_TCP_ADDR $CASSANDRA_PORT_9042_TCP_PORT

/opt/khronus/khronus-0.2/bin/khronus -f -J-Xms1g -J-Xmx1g -J-XX:NewSize=512m -Dkhronus.endpoint="$myIp" -Dakka.remote.netty.tcp.hostname="$myIp" -Dakka.cluster.seed-nodes.0="akka.tcp://khronus-system@$myIp:9400" -Dkhronus.cassandra.cluster.seeds="$CASSANDRA_PORT_9042_TCP_ADDR" -Dkhronus.cassandra.leader-election.rf=1
