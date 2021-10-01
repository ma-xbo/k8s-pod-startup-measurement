#!/bin/bash 

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd $scriptDir

IMAGE_NAME="ghcr.io/ma-xbo/basic-python-webserver:latest"
CONATINER_NAME="basic-python-webserver"
RUNTIME="io.containerd.runsc.v1" # io.containerd.runc.v1 | io.containerd.runsc.v1 | io.containerd.kata.v2
CTR="sudo microk8s ctr"

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
    echo "Ready to go"
else
    # Delete Container
    #$CTR task kill --all $CONATINER_NAME
    $CTR task rm -f $CONATINER_NAME
    $CTR c rm $CONATINER_NAME
    echo "Container '$CONATINER_NAME' removed"
fi

echo -----------

# Create and run the container
$CTR container create --runtime $RUNTIME -t $IMAGE_NAME $CONATINER_NAME
echo "Container '$CONATINER_NAME' created"

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

#TODO
#time (
#    curl localhost:5000
#    while [ current_time <= $cutoff ]; do
#        actions # Loop execution
#    done
#)