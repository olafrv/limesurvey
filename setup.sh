#!/bin/bash

URL="https://download.limesurvey.org/latest-master/limesurvey6.1.3+230612.zip"
IMAGE=$(cat docker-compose.yml | grep image | grep limesurvey | cut -d':' -f 2- | sed 's/ //')

if [ "$1" == "build" ]
then

	test -f $(basename "$URL") || wget "$URL"
	test -d limesurvey || unzip $(basename "$URL") 
	docker image rm $IMAGE
	docker build -t $IMAGE .

elif [ "$1" == "push" ]
then
	echo "Deprecated from hub.docker.com!"
#	docker login --username=olafrv
#	docker push $IMAGE
#	docker logout

elif [ "$1" == "up" ]
then

	docker-compose up -d

elif [ "$1" == "down" ]
then

	docker-compose down

fi
