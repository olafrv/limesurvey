#!/bin/bash

URL="https://download.limesurvey.org/latest-stable-release/limesurvey3.15.1+181017.zip"
WORKDIR=/var/lib/docker-compose/limesurvey
# .env file defining MYSQL_ROOT_PASSWORD
source mysql.env
MYUSER=root
MYPASS=$MYSQL_ROOT_PASSWORD
MYCONT=limesurvey_mysql
MYDDIR=/var/lib/docker-backup/$MYCONT
MYCRON=/etc/cron.d/limesurvey-backup
	
if [ "$1" == "up" ]
then

	test -f $(basename "$URL") || wget "$URL"
	test -d limesurvey || unzip $(basename "$URL") 
	docker pull phpmyadmin/phpmyadmin:4.7
	docker pull mysql:5.7.24
	#docker build -t olafrv/apache_php:2.4_7.2 -f apache_php.Dockerfile .
	#docker build -t olafrv/limesurvey:3.15 -f limesurvey.Dockerfile .
	
	docker-compose up -d

elif [ "$1" == "down" ]
then

	docker-compose down

elif [ "$1" == "backup" ]
then

cat - > "$MYCRON" <<END
21 5 * * * root /bin/bash $WORKDIR/limesurvey.sh backup
END

	mkdir -p "$MYDDIR"
	docker exec $MYCONT mysql -u $MYUSER -p$MYPASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database | while read db
	do
  	if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]]
		then 
    	echo "Dumping database: $db" 
			docker exec $MYCONT mysqldump -u $MYUSER -p$MYPASS --databases $db > $MYDDIR/db_$db.sql 
    fi 
	done 

fi

