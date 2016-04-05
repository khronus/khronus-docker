FROM library/java

RUN apt-get update && apt-get -y install libfontconfig netcat curl wget adduser openssl ca-certificates && apt-get clean

RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb

RUN dpkg -i grafana_2.6.0_amd64.deb

EXPOSE 8400 3000

VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]
VOLUME ["/etc/grafana"]

WORKDIR /opt/khronus/khronus-0.2

ADD khronus-0.2.tgz /opt/khronus

COPY scripts/start-khronus.sh /opt/khronus/

COPY scripts/khronus-dashboard.json /opt/khronus/

ENTRYPOINT ["/opt/khronus/start-khronus.sh"]
