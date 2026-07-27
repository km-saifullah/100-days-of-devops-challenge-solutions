FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 && \
    sed -i 's/Listen 80/Listen 6000/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:6000>/' /etc/apache2/sites-available/000-default.conf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6000

CMD ["apachectl", "-D", "FOREGROUND"]