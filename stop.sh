#!/bin/bash

sudo docker stop khronus-cassandra

sudo docker stop khronus

sudo docker rm khronus-cassandra

sudo docker rm khronus
