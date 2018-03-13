### Use ubuntu 16.04 for LTS
FROM ubuntu:16.04

LABEL maintainer="vinh Nguyen (quangvinh1225@gmail.com)"

# Base python images
# Install base packages and remove the apt packages cache when done.
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:jonathonf/python-3.6 \
	&& apt-get update \
    && apt-get install -y \
        apt-utils \
	    nginx \
		supervisor \
		libmysqlclient-dev \
		curl \
		build-essential \
		python3.6-dev \
		python3.6 \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/app
WORKDIR /opt/app

### Setup virtual environment and install latest uwsgi
# LC_ALL="en_US.UTF-8"
RUN export LC_ALL="en_US.UTF-8" \
	&& python3.6 -m venv venv --without-pip \
	&& . ./venv/bin/activate \
	&& curl https://bootstrap.pypa.io/get-pip.py | python3 \
	&& pip install uwsgi

### nginx configuration
# make nginx run on the foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# Redirect log to stdout, stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
# copy and replace default nginx config
COPY nginx.conf /etc/nginx/sites-enabled/default

### uwsgi configuration
# Replace default uwsgi configuration
COPY uwsgi.ini .

### supervisor configuration
# Replace default supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose ports and cmd
EXPOSE 80
CMD ["/bin/sh"]
