#!/bin/bash

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
	/set_root_pw.sh
fi
wget "http://www.spigotdl.com/jenkins/job/Spigot/lastSuccessfulBuild/artifact/BuildTools/spigot-1.8.7-R0.1-SNAPSHOT.jar" -O /data/minecraft_server.jar
echo "eula=true" > /data/eula.txt
echo "eula=true" > /data/eula.txt
echo "eula=true" > /data/eula.txt
if [ ! -f /data/eula.txt ]; then
	echo "No file called eula.txt!"
fi
service ssh restart
java -Xmx450M -jar /data/minecraft_server.jar nogui

