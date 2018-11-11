#!/bin/bash

IMAGE=olafrv/limesurvey:3.15
if [ "$1" == "destroy" ]
then
	docker image rm $IMAGE
elif [ "$1" == "push" ]
then
	docker login --username=olafrv
	docker push $IMAGE
	docker logout
else
	docker build -t $IMAGE .
fi
	
