# olafrv/limesurvey
Limesurvey Containarized Web Application

 * Source: 
   * https://github.com/olafrv/limesurvey
   * https://www.limesurvey.org/
* Images: 
   * https://hub.docker.com/r/olafrv/limesurvey
	 * https://hub.docker.com/_/php/ (PHP+Apache)
   * https://hub.docker.com/_/mysql/

## Installation

After installing git, docker and docker-compose:

* https://git-scm.com/doc
* https://docs.docker.com/install/
* https://docs.docker.com/compose/install/

Clone the git repository locally:

```bash
mkdir -p /var/lib/docker-compose
cd /var/lib/docker-compose
git clone https://github.com/olafrv/limesurvey.git
cd limesurvey
```

## Configuration

Please see Docker Network documentation to integrate other containers with the proxy:

* docker: https://docs.docker.com/compose/networking/
* docker-compose: https://docs.docker.com/engine/reference/run/#network-settings

**REMEMBER:** If your are using *docker-compose* each container's name is a DNS record
if you are using a used defined network (not the default bridge), so any container can
access each other using their names.

You must create a user defined network, here is named **composed** network to avoid 
errors during composing:

```bash
docker network create --driver=bridge --subnet=172.29.4.0/24 --gateway=172.29.4.1 composed
```
Attach the **composed** network to your containers (docker run --network) or
define the **composed** network for your service stack (docker-compose.yml):

```
networks:
  composed:
    external:
      name: composed

```

You must define at least two **environment files**:

 * mysql.env (See docker-compose.yml to know which variables must be defined)
 * phpmyadmin.env (See docker-compose.yml to know which variables must be defined)
 * limesurvey.env (Optional, just to save notes, password or anything else about limesurvey installer)

## Control

Compose up/down the service stack or dump all mysql databases (backup):

```bash
. limesurvey.sh [up|down|backup]
```

## Backup

You must fully backup the following directories:
  * /var/lib/docker-compose/limesurvey
  * /var/lib/docker-backup/limesurvey (MySQL Dumps Destination)

