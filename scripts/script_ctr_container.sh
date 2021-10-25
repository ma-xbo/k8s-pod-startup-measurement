#!/bin/bash 

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd $scriptDir

# Prerequisites
# - Make sure the Kubernetes RuntimeClass for the respective Container Runtime has been created before running the script

IMAGE_NAME="ghcr.io/ma-xbo/basic-python-webserver:latest"
CONATINER_NAME="basic-python-webserver"
RUNTIME="io.containerd.runc.v1" # io.containerd.runc.v1 | io.containerd.runsc.v1 | io.containerd.kata.v2 | io.containerd.kata-fc.v2
CTR="sudo ctr"

# check if the defined container image is already been pulled
image=$($CTR i ls | grep $IMAGE_NAME)
if [ -z "$image" ]
then
    # Image does not exist - Download the container image
    $CTR i pull $IMAGE_NAME
    echo "Container Image '$IMAGE_NAME' successfully pulled"
else
    # Container Images already present
    echo "Container Image '$IMAGE_NAME' has already been pulled"
fi

# check if the defined container is already running
container=$($CTR c ls | grep $IMAGE_NAME)
if [ -z "$container" ]
then
    # Container does not exist
    echo "Container does not exist"
else
    # Delete Container
    $CTR task rm -f $CONATINER_NAME
    $CTR c rm $CONATINER_NAME
    echo "Container '$CONATINER_NAME' removed"
fi

sleep 1.0s
echo -----------

time (
    # Create the container
    if [ "$RUNTIME" == "io.containerd.kata-fc.v2" ]
    then
        # Create Container with snapshotter "devmapper"
        $CTR container create --snapshotter devmapper --runtime $RUNTIME -t $IMAGE_NAME $CONATINER_NAME
    else
        # Create Container with default snapshotter
        $CTR container create --runtime $RUNTIME -t $IMAGE_NAME $CONATINER_NAME
    fi
    echo "Container '$CONATINER_NAME' created"

    # Start the Container
    $CTR task start -d $CONATINER_NAME
    echo "Container '$CONATINER_NAME' started"

    echo -----------

    # Polling curl localhost:5000
    response_status=$($CTR task exec -t --exec-id curl1 basic-python-webserver curl -s -o -I -w "%{http_code}" 127.0.0.1:5000)
    while [ "$response_status" != "200" ] 
    do
        response_status=$($CTR task exec -t --exec-id curl1 basic-python-webserver curl -s -o -I -w "%{http_code}" 127.0.0.1:5000)
        echo "Response status: $response_status"
    done
)
