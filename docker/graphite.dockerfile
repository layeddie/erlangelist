FROM hopsoft/graphite-statsd:latest
COPY docker/graphite/storage-schemas.conf docker/graphite/storage-aggregation.conf /opt/graphite/conf/
COPY docker/graphite/start.sh /home/root/start.sh