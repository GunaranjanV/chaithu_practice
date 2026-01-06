#!/bin/bash

docker_status=$(systemctl is-active docker)
docker_version=$(docker --version | awk '{print $3}' | tr -d ',')
current_date=$(date)
to="gunaachar003@gmail.com"
subject="Docker service alert"

echo "Docker status on $(hostname) at $current_date is: $docker_status"
echo "Docker version as on $current_date is: $docker_version"

if [ "$docker_status" != active ];
then
	echo -e "Docker status is $docker_status on $(hostname). Docker will be going to restart in next 10 seconds" | mail -s "$subject" $to

sleep 10
sudo systemctl restart docker
new_status=$(systemctl is-active docker)
new_date=$(date)

if [ "$new_status" == active ];
then
	echo -e "Docker has restarted successfully at $new_date. Docker status is $new_status and its healthy" | mail -s "$subject" $to
else
	echo -e "Docker restart unsuccessfull. Please look into it" | mail -s "$subject" $to
fi
fi
