#!/bin/bash

# download khronus
[ -f "khronus-0.2.tgz" ] && echo "Khronus exists, nothing to do" ||  wget "https://github.com/Searchlight/khronus/releases/download/v0.2.0/khronus-0.2.tgz"

./stop.sh

docker build -t searchlight/khronus-slim .

# start cassandra container
docker run --name khronus-cassandra -d cassandra:2.1.13

# start khronus & grafana container
docker run --name khronus-slim -i -p 3000:3000 -p 8400:8400 --link khronus-cassandra:cassandra -d searchlight/khronus-slim && echo "Open http://localhost:3000/dashboard/db/example-dashboard and login with admin/admin"
