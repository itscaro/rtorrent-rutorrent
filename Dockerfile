FROM ubuntu:xenial
USER root

# add extra sources 
ADD ./extra.list /etc/apt/sources.list.d/extra.list

# install
RUN apt-get update && \
    apt-get install -y --force-yes rtorrent unzip unrar mediainfo curl php-fpm php-cli php-geoip nginx wget ffmpeg supervisor python3-pip&& \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install chaperone

# download rutorrent
RUN mkdir -p /var/www && \
    wget --no-check-certificate https://bintray.com/artifact/download/novik65/generic/ruTorrent-3.7.zip && \
    unzip ruTorrent-3.7.zip && \
    mv ruTorrent-master /var/www/rutorrent && \
    rm ruTorrent-3.7.zip

COPY chaperone.conf /etc/chaperone.d/chaperone.conf

ADD ./config.php /var/www/rutorrent/conf/

# configure nginx
ADD rutorrent-*.nginx /root/

# add startup scripts and configs
ADD startup-rtorrent.sh startup-nginx.sh startup-php.sh .rtorrent.rc /root/

# configure supervisor
ADD supervisord.conf /etc/supervisor/conf.d/

EXPOSE 80 443 49160 49161

VOLUME /downloads

ENTRYPOINT ["/usr/local/bin/chaperone"]
