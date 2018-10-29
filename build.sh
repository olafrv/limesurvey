URL="https://download.limesurvey.org/latest-stable-release/limesurvey3.15.1+181017.zip"

test -f $(basename "$URL") || wget "$URL"
test -d limesurvey || unzip $(basename "$URL") 
docker pull phpmyadmin/phpmyadmin:4.7
docker pull mysql:5.7.24
docker build -t daycohost/apache_php:2.4_7.2 -f apache_php.Dockerfile .
docker build -t daycohost/limesurvey:3.15 -f limesurvey.Dockerfile .
	
