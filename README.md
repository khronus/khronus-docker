khronus-docker - (Khronus + Grafana + Cassandra)
======

Docker container with Khronus, Grafana and Cassandra. Actually, it is composed by two containers: Khronus+Grafana linked to an [official Cassandra container](https://hub.docker.com/_/cassandra/). It is intended to be the best way to getting started to Khronus. For production is recommended to configure and run a Khronus cluster following the instructions [here](https://github.com/Searchlight/khronus#installation).

##Instructions

1. Clone the repo
2. Execute run.sh
3. Go to [Grafana on http://localhost:3000/dashboard/db/khronus-cluster](http://localhost:3000/dashboard/db/khronus-cluster)
4. There is an example dashboard to use as an example and to start playing with it. Give Khronus some time to collect some internal metrics.
5. Enjoy!
