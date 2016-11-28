FROM library/java:jre-alpine

RUN apk add --update bash snappy
RUN apk add --update java-snappy --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

ADD grafana-bins/grafana-alpine-build.tgz /
ADD khronus-0.2.tgz /opt/khronus
COPY scripts /opt/khronus/

#Replace java-snappy jar with the one from alpine
RUN find /opt -name "*snappy*jar" | xargs -n1 cp /usr/share/java/snappy-java.jar

#Allow anonymous access to grafana
RUN sed -i -r '$!N;s/(access\s+enabled\s*=\s*)false/\1true/I' /etc/grafana/grafana.ini

#8400 for khronus-influx, 3000 grafana
EXPOSE 8400 3000

#Khronus
ENTRYPOINT ["/opt/khronus/start-khronus.sh"]
