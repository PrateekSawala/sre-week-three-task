#!/bin/bash

# Define variables
NAMESPACE="sre" 
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=4

# Start an infinite loop
while true; do
    # Find the restart count of the first pod
    RESTART_COUNT=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o=jsonpath='{.items[0].status.containerStatuses[*].restartCount}')
    echo "Current restart count for $DEPLOYMENT_NAME in $NAMESPACE: $RESTART_COUNT"

    # Check if the restart count exceeds the maximum allowed
    if [[ RESTART_COUNT -gt MAX_RESTARTS ]]; then
        echo "Restart count exceeded limit. Scaling down $DEPLOYMENT_NAME to 0 replicas."
        kubectl scale deployment $DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
        break
    fi
    sleep 60
done
