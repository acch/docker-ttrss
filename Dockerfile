FROM php:7-apache-stretch
MAINTAINER Achim Christ

# Install prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update \
&& apt-get -qqy install \
   libfreetype6-dev \
   libjpeg-dev \
   libpng-dev \
   supervisor \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-install mysqli pdo_mysql \
&& docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
&& docker-php-ext-install gd

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose database credentials for overwriting
ENV MYSQL_HOST localhost
ENV MYSQL_USER fox
ENV MYSQL_DATABASE fox
ENV MYSQL_PASS XXXXXX

# Expose Email settings for overwriting
ENV SMTP_SERVER localhost:25
ENV SMTP_FROM_NAME Tiny-Tiny-RSS
ENV SMTP_FROM_ADDRESS noreply@your.domain.dom

# Add config script for applying database credentials and Email settings
COPY config.sh /var/www/html

# Install Tiny Tiny RSS and SMTP mailer plugin
RUN curl -sSL https://git.tt-rss.org/fox/tt-rss/archive/master.tar.gz | tar xz -C /var/www/html --strip-components 1 \
&& mkdir /var/www/html/plugins.local/mailer_smtp \
&& curl -sSL https://git.tt-rss.org/fox/ttrss-mailer-smtp/archive/master.tar.gz | tar xz -C /var/www/html/plugins.local/mailer_smtp --strip-components 1 \
&& chown -R www-data:www-data /var/www/html

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
