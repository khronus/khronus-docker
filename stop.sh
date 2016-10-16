#!/bin/bash

docker stop khronus-cassandra
docker stop khronus-slim
docker rm khronus-cassandra
docker rm khronus-slim

