#!/bin/bash
# Install script for the Aerial Tactile Servoing drone flight computer

# Check if the script is being run with sudo or as root
if [[ "$EUID" -ne 0 ]]; then
   echo "This script must be run as root or with sudo privileges." 
   exit 1
fi

# Variables for script and service paths
SCRIPT_DIR="./scripts"
SERVICE_DIR="./services"
SYSTEMD_PATH="/etc/systemd/system"

# 1. Make the necessary scripts executable
echo "Making scripts executable..."
for script in micro_xrce.sh zenoh_bridge.sh mavlink_router.sh wifi_ap.sh; do
    if [[ -f $SCRIPT_DIR/$script ]]; then
        chmod u+x $SCRIPT_DIR/$script || { echo "Failed to make $SCRIPT_DIR/$script executable"; exit 1; }
        echo "Made $SCRIPT_DIR/$script executable."
    else
        echo "Script file not found: $SCRIPT_DIR/$script"
        exit 1
    fi
done

# 2. Copy the service files to /etc/systemd/system/
echo "Copying service files to $SYSTEMD_PATH..."
for service in zenoh-bridge.service micro-xrce-dds-agent.service mavlink-router.service wifi-ap.service; do
    if [[ -f $SERVICE_DIR/$service ]]; then
        cp $SERVICE_DIR/$service $SYSTEMD_PATH/ || { echo "Failed to copy $SERVICE_DIR/$service to $SYSTEMD_PATH"; exit 1; }
        echo "Copied $SERVICE_DIR/$service to $SYSTEMD_PATH"
    else
        echo "Service file not found: $SERVICE_DIR/$service"
        exit 1
    fi
done

# 3. Reload the systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload || { echo "Failed to reload systemd daemon"; exit 1; }

# 4. Enable the necessary services
echo "Enabling services..."
for service in micro-xrce-dds-agent.service mavlink-router.service zenoh-bridge.service; do
    systemctl enable $service || { echo "Failed to enable $service"; exit 1; }
    echo "Enabled $service"
done
# Optionally enable wifi-ap.service if needed
# systemctl enable wifi-ap.service

# 5. Start the services
echo "Starting services..."
for service in micro-xrce-dds-agent.service mavlink-router.service zenoh-bridge.service; do
    systemctl start $service || { echo "Failed to start $service"; exit 1; }
    echo "Started $service"
done
# Optionally start wifi-ap.service if needed
# systemctl start wifi-ap.service

# 6. Check the status of the services to confirm they're running
echo "Checking service statuses..."
for service in micro-xrce-dds-agent.service mavlink-router.service zenoh-bridge.service; do
    systemctl is-active --quiet $service && echo "$service is running." || { echo "$service failed to start."; exit 1; }
done
# Optionally check wifi-ap.service status if needed
# systemctl is-active --quiet wifi-ap.service && echo "wifi-ap.service is running." || echo "wifi-ap.service failed to start."
