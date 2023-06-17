#!/bin/bash

CURDIR=$(pwd)
MYUSER=$(cat docker-compose.yml | grep MYSQL_USER | cut -d':' -f 2- | sed 's/[" ]//g')
MYPASS=$(cat docker-compose.yml | grep MYSQL_PASS | cut -d':' -f 2- | sed 's/[" ]//g')
MYCONT=$(cat docker-compose.yml | grep MYSQL_DATABASE | cut -d':' -f 2- | sed 's/[" ]//g')
MYDDIR="./backup"
MYCRON=/etc/cron.d/limesurvey-backup

sudo tee -a "$MYCRON" <<END
21 5 * * * root /bin/bash $CURDIR/backup.sh
END

mkdir -p "$MYDDIR"
docker exec "$MYCONT" mysql -u "$MYUSER" -p"$MYPASS" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database | while read db
do
if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]]
    then 
        echo "Dumping database: $db" 
        docker exec "$MYCONT" mysqldump -u "$MYUSER" -p"$MYPASS" --databases "$db" > "$MYDDIR/db_$db.sql" 
    fi 
done 