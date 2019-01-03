#!/usr/bin/env bash

nodeAppSource=`cd ../../ && pwd`

ALREADY_EXISTS=125

runSpinner() {
    COUNTER=0
    SPINNER="-\|/"
    DURATION=$1
    while [ $COUNTER -lt $DURATION ]; do
        printf "\b${SPINNER:COUNTER++%${#SPINNER}:1}"
        sleep 1 
    done
    printf "\b"
}

docker network ls | grep -o "isolated_network" 1>/dev/null 2>&1
if [ "$?" -ne "0" ]; then
    echo "Creating isolated network for dev environment."
    docker network create --driver bridge isolated_network
fi

DOCKER_HUB=scirelli
CONTAINER_NAME=scraper-api
tag=latest
echo ""
echo "Starting $CONTAINER_NAME"
repo="$DOCKER_HUB/$CONTAINER_NAME"
docker run \
    --detach \
    --name "$CONTAINER_NAME" \
    --mount type=bind,source="$nodeAppSource",target=/code \
    --env NPM_CONFIG_LOGLEVEL=info \
    --net=isolated_network \
    --publish 1111:80 \
    --publish 9229:9229 \
    --publish 9222:9222 \
    --publish 9221:9221 \
    "$repo:$tag"
    # /bin/bash -c "npm run-script docker-cmd" 1>/dev/null 2>&1
webNodeDev=$?
if [ "$webNodeDev" -eq "$ALREADY_EXISTS" ]; then
    echo "Container exists, starting it."
    docker start $CONTAINER_NAME
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

docker container list -a

HOST=localhost
PORT=1111
WAIT_TIME=20
echo "#######################################################################"
echo "# Environment is spinning up. Give Node a few seconds (~$WAIT_TIME) to start. #"
echo "# Then open http://$HOST:$PORT                                     #"
echo "#######################################################################"
runSpinner $WAIT_TIME

statusCode=`curl --silent --head --write-out "%{http_code}" --output /dev/null http://localhost:1111`
if [ $statusCode != "200" ]; then
    echo "Looks like the container is taking longer than expected to start."
    echo "You can wait a little longer or try looking at the logs to see if there was an issue. 'Docker logs $CONTAINER_NAME'"
    runSpinner 5
fi

if [ $(uname) == "Darwin" ]; then
    open -a "Google Chrome" http://$HOST:$PORT
fi
