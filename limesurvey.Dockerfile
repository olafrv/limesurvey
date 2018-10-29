FROM daycohost/apache_php:2.4_7.2
MAINTAINER Olaf Reitmaier <olafrv@gmail.com>
WORKDIR /var/www/html/limesurvey
COPY limesurvey .
RUN chmod -R 777 ./tmp \
		&& chmod -R 777 ./upload \
		&& chmod -R 777 ./application/config
