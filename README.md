# MMRELAYNODE
## *A Dockerized Relay for Meshtastic and Matrix featuring an Integrated Virtual Meshtastic Node communicating via MQTT*

### **Introduction**

This project utilizes a virtual node built using [Meshtastic firmware](https://github.com/meshtastic/firmware). It emulates the capabilities of a physical device, facilitating direct communication with a conventional mesh network through the firmware's built-in MQTT functionality.

The relay operations are provided by the [Meshtastic <=> Matrix Relay](https://github.com/geoffwhittington/meshtastic-matrix-relay) project.

Discover more about Meshtastic on their official site: [https://meshtastic.org](https://meshtastic.org).

### **Installation & Setup**

This project consists of two containers `mmrealynode-app` and `mmrelaynode-device`. Start by copying `docker-compose-sample.yaml` to `docker-compose.yaml` and tailor it to your needs.

For container setup:

```
git clone https://github.com/mate-dev/mmrelaynode.git
cd mmrelaynode && git submodule update --init
docker compose -f "docker-compose.yaml" up -d --build
docker compose restart
```

*Important: Restart the containers after the initial launch. This reboot enables the virtual Meshtastic node to apply the changes from the `MESHTATIC_COMMAND_X:` commands after being executed by the script.*

### **Additional Operational Commands**

To view outputs from `command_wrapper.py` & `MESHTASTIC_COMMAND_X` commands:
```
docker exec -it mmrelaynode-app cat /home/mesh/app/command_output.txt
```

These commands are executed only upon the first launch of the container. To re-execute, remove the flag file and restart the container.

To remove the flag file:
```
docker exec -it mmrelaynode-app rm /home/mesh/app/.commands_executed
```

For script modifications and rebuilding containers from scratch, use:

```
docker compose down --volumes
docker compose build --no-cache
docker compose up -d --force-recreate 
```

### Health Check

A Python script in the app container can sometimes hang due to a connection problem with the device container, halting its operation. Therefore, it's worth adding a health check that monitors the app container logs and restarts the container if an error is detected.

The simplest way to perform the check is to use cron, which will check the logs every minute. To do this, we go into edit mode with `crontab -e` and add the path to the `healthcheck.sh` file (remember to leave the last line empty).

```
user@server$ crontab -e

# m h  dom mon dow   command
* * * * * /bin/bash /path/to/file/mmrelaynode/healthcheck.sh

```
