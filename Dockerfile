FROM httpd:2.4.23

# libmysqlclient-dev: necesaria para mysql_config, opción necesaria para obtener el controlador MYSQLI en compilación
# mysql-client - porque estamos usando MySQL 5.7 en un contenedor diferente
# libxml2-dev - dependencia para compilar PHP
# gcc, make - necesita un compilador de C para compilar PHP
# curl - herramienta útil para depurar en el contenedor

RUN apt-get update && apt-get install -y \
    mysql-client \
    libmysqlclient-dev \
    gcc \
    libxml2-dev \
    make \
    curl \
    vim

# Nos permite  ejecutar los comando en la imagen base, antes de ser creada.

RUN curl https://www.php.net/distributions/php-5.6.40.tar.gz > /tmp/php-5.6.40.tar.gz

RUN cd /tmp && tar -zxvf php-5.6.40.tar.gz
RUN cd /tmp/php-5.6.40 && \
    ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql --with-mysqli=/usr/bin/mysql_config \
    --enable-mbstring && \
    make && make install
RUN rm -rf /tmp/php-5.6.40

WORKDIR /var/www/coavi_docker/coavi  
RUN mkdir -p /var/log/apache2

COPY ./test-coavi-httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80

CMD ["httpd-foreground"]