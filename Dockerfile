FROM ubuntu
ENV user=guna
RUN apt-get update && \
    apt-get -y apache2 && \
    apt-get clean

COPY index.html var/www/html/index.html
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
