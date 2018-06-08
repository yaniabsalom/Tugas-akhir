# Dockerfile untuk Web server apache + PHP

# Image diturunkan dari Ubuntu LTS
FROM ubuntu:14.04.2

MAINTAINER Husni

#U pdate database paket dan instal semua yang diperlukan
# curl dan lynx-cur digunakan untuk debugging container
# Enable apache mods.
# Update file PHP.ini , enable-kan tag dan quieten logging.
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive \
apt-get -y install apache2 \
libapache2-mod-php5 \
php5-mysql \
php5-gd \
php-pear \
php-apc \
php5-curl \
curl \
lynx-cur && \
a2enmod php5 && \
a2enmod rewrite && \
sed -i “s/short_open_tag = Off/short_open_tag = On/” /etc/php5/apache2/php.ini && \
sed -i “s/error_reporting = .*$/error_reporting = E_ERROR | \
E_WARNING | E_PARSE/” /etc/php5/apache2/php.ini
# Setup variabel lingkungan dari apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Port 80 dipublish ke Host
EXPOSE 80

# Tambahkan halaman web (aplikasi) default ke /var/www/
ADD webdata/ /var/www/

# Update situs apache default dengan konfigurasi yang kita buat.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
# Secara default, jalankan apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
