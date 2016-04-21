FROM 32bit/ubuntu:14.04
USER root

# add extra sources 
ADD ./extra.list /etc/apt/sources.list.d/extra.list

# install
RUN apt-get update && \
    apt-get install -y --force-yes rtorrent unzip unrar mediainfo curl php5-fpm php5-cli php5-geoip nginx wget ffmpeg supervisor git-core && \
    rm -rf /var/lib/apt/lists/*

# configure nginx
ADD rutorrent-*.nginx /root/

# download rutorrent
RUN mkdir -p /var/www/ && cd /var/www && \
    git clone https://github.com/Novik/ruTorrent.git rutorrent && \
    rm -rf ./rutorrent/.git*
ADD ./config.php /var/www/rutorrent/conf/

# add startup scripts and configs
ADD startup-rtorrent.sh startup-nginx.sh startup-php.sh .rtorrent.rc /root/

# configure supervisor
ADD supervisord.conf /etc/supervisor/conf.d/

EXPOSE 80
EXPOSE 443
EXPOSE 49160
EXPOSE 49161
VOLUME /downloads

CMD ["supervisord"]

