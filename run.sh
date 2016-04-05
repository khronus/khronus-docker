#!/bin/bash

# download khronus
[ -f "khronus-0.2.tgz" ] && echo "Khronus exists, nothing to do" ||  wget "https://github.com/Searchlight/khronus/releases/download/v0.2.0/khronus-0.2.tgz"

sudo docker stop khronus-cassandra

sudo docker stop khronus

sudo docker rm khronus-cassandra

sudo docker rm khronus

# start cassandra container
sudo docker run --name khronus-cassandra -d cassandra:2.1.13

sudo docker build -t searchlight/khronus .

# start khronus container
# start grafana container
sudo docker run --name khronus -i -p 3000:3000 -p 8400:8400 --link khronus-cassandra:cassandra -d searchlight/khronus
