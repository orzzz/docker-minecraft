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
FROM   ubuntu:latest


# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive


# Download and install everything from the repos.
RUN    apt-get --yes update; apt-get --force-yes upgrade; apt-get --yes install software-properties-common axel
RUN    apt-add-repository --force-yes ppa:webupd8team/java; apt-get --force-yes update
RUN    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
       echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
       apt-get --force-yes install curl oracle-java8-installer


# Load in all of our config files.
ADD    set_root_pw.sh /set_root_pw.sh
ADD    run.sh /run.sh
ADD    ./plugins /data/plugins

# Fix all permissions
RUN    chmod +x /*.sh
RUN    axel -n 10 "http://www.spigotdl.com/jenkins/job/Spigot/lastSuccessfulBuild/artifact/BuildTools/spigot-1.8.7-R0.1-SNAPSHOT.jar" -o /data/minecraft_server.jar
RUN    echo "eula=true" > /data/eula.txt
RUN    apt-get -y autoclean

# 25565 is for minecraft
EXPOSE 25565
EXPOSE 22

# /data contains static files and database
VOLUME ["/data"]

# /start runs it.
CMD    ["/run.sh"]
