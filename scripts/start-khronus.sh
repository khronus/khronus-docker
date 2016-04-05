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

cd /usr/share/grafana && nohup /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana &

waitFor localhost 3000

curl 'http://admin:admin@localhost:3000/api/datasources' -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' --data-binary '{"name":"khronus","type":"influxdb_08","isDefault": true,"url":"http://localhost:8400/khronus","access":"direct","database":"influx","user":"test","password":"test"}' --compressed

curl 'http://admin:admin@localhost:3000/api/dashboards/db/' -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/json;charset=UTF-8' --data-binary @/opt/khronus/khronus-dashboard.json --compressed

waitFor $CASSANDRA_PORT_9042_TCP_ADDR $CASSANDRA_PORT_9042_TCP_PORT

myIp=$(hostname --ip-address)

bin/khronus -f -J-Xms1g -J-Xmx1g -J-XX:NewSize=512m -Dkhronus.endpoint="$myIp" -Dakka.remote.netty.tcp.hostname="$myIp" -Dakka.cluster.seed-nodes.0="akka.tcp://khronus-system@$myIp:9400" -Dkhronus.cassandra.cluster.seeds="$CASSANDRA_PORT_9042_TCP_ADDR" -Dkhronus.cassandra.leader-election.rf=1
