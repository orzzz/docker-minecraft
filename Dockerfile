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


# Download and install everything from the repos.
RUN    apt-get --yes update; apt-get --yes upgrade; apt-get --yes install software-properties-common axel
RUN    apt-get -y autoclean
RUN    service ssh restart
RUN    sudo apt-add-repository --yes ppa:webupd8team/java; apt-get --yes update
RUN    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
       echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
       apt-get --yes install curl oracle-java8-installer


# Load in all of our config files.
ADD    ./scripts/start /start
ADD    set_root_pw.sh /set_root_pw.sh
ADD    run.sh /run.sh
ADD    ./plugins /data/plugins

# Fix all permissions
RUN    chmod +x /start
RUN    chmod +x /*.sh
RUN    axel -n 10 "http://www.spigotdl.com/jenkins/job/Spigot/lastSuccessfulBuild/artifact/BuildTools/spigot-1.8.7-R0.1-SNAPSHOT.jar" -O /data/minecraft_server.jar
RUN    echo "eula=true" > /data/eula.txt

# 25565 is for minecraft
EXPOSE 25565
EXPOSE 22

# /data contains static files and database
VOLUME ["/data"]

# /start runs it.
CMD    ["/run.sh"]
