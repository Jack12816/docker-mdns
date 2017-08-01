FROM nginx:latest

RUN apt-get update -yy && \
    apt-get install -yy \
        avahi-daemon avahi-discover avahi-utils libnss-mdns \
        iputils-ping dnsutils

COPY config/avahi-daemon.conf /etc/avahi/avahi-daemon.conf

COPY config/start.sh /
RUN chmod +x /start.sh

CMD /start.sh
