# Namada Monitoring Script

This is a Bash script to monitor the Namada service and relaunch it automatically if it crashes.

## Features
- Continuously monitors the Namada service and relaunches it if it crashes.
- Sends a webhook notification when the node is down and a relaunch occurs.
- Waits for a specified time before checking the Namada node status again.
- Waits for a longer time before checking again if a relaunch fails.


## Requirements

- `namada` command-line tool installed on the machine https://docs.namada.net/introduction/quick-start
- curl

## Usage

1. Edit the script to set your webhook (Telegram, Discord...) URL and Namada command.
2. Make the script executable: `chmod +x namada_monitor.sh`
3. Run the script in background `nohup ./namada_monitor.sh &`

### Configuration

The script has the following configuration options:

- `SERVICE_NAME`: the Namada service name.
- `WEBHOOK_URL`: the URL of the webhook to use for notifications.
- `START_CMD`: the command to use to start the Namada node service.
- `WAIT_TIME`: the time to wait before checking the status of the Celestia process again (in seconds).
- `RELAUNCH_WAIT_TIME`: the time to wait before attempting to relaunch the Celestia process after a failure (in seconds).
