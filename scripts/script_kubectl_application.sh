#!/bin/bash 

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd $scriptDir

# Prerequisites
# - Make sure the Kubernetes RuntimeClass for the respective Container Runtime has been created before running the script

FILENAME="../k8s-definitions/k8s-basic-python-webserver.yaml"
CONATINER_NAME="basic-python-webserver"
DEPLOYMENT_NAME="basic-python-webserver-deployment"
SERVICE_NAME="basic-python-webserver-service"
KUBECTL="sudo microk8s kubectl"

# Check if Kubernetes Service already exists
service=$($KUBECTL get service | grep $SERVICE_NAME)
if [ -z "$service" ]
then
    # Service does not exist
    echo "Service does not exist"
else
    # Service does exist -> has to be deleted
    $KUBECTL delete service/$SERVICE_NAME
fi

# Check if Kubernetes Deployment already exists
deployment=$($KUBECTL get deployment | grep $DEPLOYMENT_NAME)
if [ -z "$deployment" ]
then
    # Deployment does not exist
    echo "Deployment does not exist"
else
    # Deployment does exist -> has to be deleted
    $KUBECTL delete deployment/$DEPLOYMENT_NAME
    
    # Check Status of the Pod -> Wait until Pod is terminated
    echo "Wait until Pod is terminated:"
    pod_phase=$($KUBECTL get po --selector=app=$CONATINER_NAME -o jsonpath='{.items[*].status.phase}')
    while [ "$pod_phase" == "Running" ]  
    do
        pod_phase=$($KUBECTL get po --selector=app=$CONATINER_NAME -o jsonpath='{.items[*].status.phase}')
        sleep 0.5s
        
        if [ -z "$pod_phase" ]
        then
            pod_phase="Terminated"
        fi
        echo "Pod status: $pod_phase"
    done
fi

echo ------------------------

time (
    # Run the container
    $KUBECTL apply -f ./$FILENAME

    echo ------------------------

    # Check Pod phase -> wait until Pod is running
    echo "Wait until Pod is running:"
    pod_phase=$($KUBECTL get po --selector=app=$CONATINER_NAME -o jsonpath='{.items[*].status.phase}')
    while [ "$pod_phase" != "Running" ] 
    do
        pod_phase=$($KUBECTL get po --selector=app=$CONATINER_NAME -o jsonpath='{.items[*].status.phase}')
        echo "Pod status: $pod_phase"
    done

    echo ------------------------

    # Get the ClusterIP of the Kubernetes Service
    service_ip=$($KUBECTL get service/$SERVICE_NAME -o jsonpath='{.spec.clusterIP}')
    echo "The ClusterIP of the service/$SERVICE_NAME is: $service_ip"  

    echo ------------------------

    # Send request to the web server -> curl service_ip:5000
    echo "Send request to the web server"
    response_status=$(curl -s -o --head -w "%{http_code}" $service_ip:5000)
    while [ "$response_status" != "200" ] 
    do
        response_status=$(curl -s -o --head -w "%{http_code}" $service_ip:5000)
        echo "Response: $response_status"
    done

    # Print the response to the command line
    response=$(curl $service_ip:5000)
    echo "Response of the web server: '$response'"
)
