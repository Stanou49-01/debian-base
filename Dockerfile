FROM debian:latest
MAINTAINER Damien Lagae <damien@lagae.info>

# Set the enviroment variable
ENV DEBIAN_FRONTEND noninteractive

# Configure timezone
RUN echo "Europe/Brussels" > /etc/timezone && dpkg-reconfigure tzdata

# Install required packages
RUN apt-get clean all && apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install supervisor curl git wget build-essential python-setuptools

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Config supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD conf/stdout.conf /etc/supervisor/conf.d/stdout.conf

# Add shell scripts for starting supervisor
ADD shell/run.sh /run.sh

# Give the execution permissions
RUN chmod 755 /*.sh

# Run
CMD ["/run.sh"]
