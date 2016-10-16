FROM library/java:jre-alpine

RUN apk add --update bash curl snappy
RUN apk add --update java-snappy --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

ADD grafana-bins/grafana-alpine-build.tgz /
ADD khronus-0.2.tgz /opt/khronus
COPY scripts /opt/khronus/
#REPLACE java-snappy jar with the one from alpine
RUN find /opt -name "*snappy*jar" | xargs -n1 cp /usr/share/java/snappy-java.jar

#8400 for khronus-influx, 3000 grafana
EXPOSE 8400 3000

#Khronus
ENTRYPOINT ["/opt/khronus/start-khronus.sh"]
