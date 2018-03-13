FROM tiangolo/uwsgi-nginx:python3.6

LABEL maintainer="vinh Nguyen (vinh.nguyen@ecotruck.vn)"

RUN mkdir /opt/application
WORKDIR /opt/application

# Install required packages and remove the apt packages cache when done.
RUN apt-get update \
    && apt-get install -y \
        apt-utils \
        libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

#expose ports and cmd
EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
