# -----------------------------------------------------------------------------
# docker-minecraft
#
# Builds a basic docker image that can run a Minecraft server
# (http://minecraft.net/).
#
# Authors: Isaac Bythewood
# Updated: Dec 14th, 2014
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------


# Base system is the LTS version of Ubuntu.
FROM   ubuntu:14.04


# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive
ENV    AUTHORIZED_KEYS **None**

# /data contains static files and database
VOLUME ["/data"]

# Download and install everything from the repos.
RUN    apt-get --yes update; apt-get --yes upgrade; apt-get --yes install software-properties-common axel openssh-server pwgen
RUN    mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN    apt-add-repository --yes ppa:webupd8team/java
RUN    apt-get --yes update
RUN    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
       echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
       apt-get --yes install oracle-java8-installer


# Load in all of our config files.
ADD    set_root_pw.sh /set_root_pw.sh
ADD    run.sh /run.sh
ADD    ./plugins /plugins

# Fix all permissions
RUN    chmod +x /*.sh
RUN    apt-get -y autoclean

# 25565 is for minecraft
EXPOSE 25565
EXPOSE 22

# /start runs it.
CMD    ["/run.sh"]
