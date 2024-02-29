#!/bin/bash

# Define the webhook URL
WEBHOOK_URL="https://your-webhook-url-here.com"

# Define the service name
SERVICE_NAME="namadad.service"

# Define the command to start the service
# Assuming Namada service is managed by systemd and a service file exists
START_CMD="systemctl start $SERVICE_NAME"

# Define the time to wait before checking the status again (in seconds)
WAIT_TIME=300 # 5 minutes

# Define the time to wait before checking the status again after a relaunch failure (in seconds)
RELAUNCH_WAIT_TIME=1800 # 30 minutes

# Initialize the last relaunch time
LAST_RELAUNCH_TIME=$(date +%s)

# Infinite loop to continuously monitor the service
while true
do
    # Check if the Namada service is active
    if systemctl is-active --quiet $SERVICE_NAME
    then
        echo "$SERVICE_NAME is running"
    else
        echo "$SERVICE_NAME is not running, attempting to restart..."
        # Send alert that the service has stopped
        curl -H "Content-Type: application/json" -d '{"content":"The '$SERVICE_NAME' service has stopped."}' $WEBHOOK_URL
        
        # Attempt to restart the service
        $START_CMD
        
        # Check if the service restarted successfully
        if systemctl is-active --quiet $SERVICE_NAME
        then
            # Service restarted successfully
            echo "$SERVICE_NAME has been restarted."
            # Send webhook to confirm the service is running again
            curl -H "Content-Type: application/json" -d '{"content":"The '$SERVICE_NAME' service has been restarted."}' $WEBHOOK_URL
            LAST_RELAUNCH_TIME=$(date +%s)
        else
            # Service failed to restart
            echo "Failed to restart $SERVICE_NAME."
            # Send webhook to alert failure to restart
            curl -H "Content-Type: application/json" -d '{"content":"Failed to restart the '$SERVICE_NAME' service."}' $WEBHOOK_URL
        fi
    fi

    # Wait for the specified time before checking the status again
    sleep $WAIT_TIME
done
