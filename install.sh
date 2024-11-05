#! /bin/sh

# 1. Make the script executable
chmod u+x ./scripts/micro_xrce.sh
chmod u+x ./scripts/zenoh_bridge.sh
chmod u+x ./scripts/mavlink_router.sh
chmod u+x ./scripts/wifi_ap.sh

# 2. Copy the service file
sudo cp ./services/zenoh-bridge.service /etc/systemd/system/zenoh-bridge.service
sudo cp ./services/micro-xrce-dds-agent.service /etc/systemd/system/micro-xrce-dds-agent.service
sudo cp ./services/mavlink-router.service /etc/systemd/system/mavlink-router.service
sudo cp ./services/wifi-ap.service /etc/systemd/system/wifi-ap.service

# 3. reload the daemon
sudo systemctl daemon-reload

# 4. Enable the services
sudo systemctl enable micro-xrce-dds-agent.service
sudo systemctl enable mavlink-router.service
sudo systemctl enable zenoh-bridge.service
#sudo systemctl enable wifi-ap.service

# 5. Start the services
sudo systemctl start micro-xrce-dds-agent.service
sudo systemctl start mavlink-router.service
sudo systemctl start zenoh-bridge.service
#sudo systemctl start wifi-ap.service

# 6. Check the status of the service to confirm it's running
# sudo systemctl status your_service.service
