# Aerial Tactile Servoing setup and configurations
Systemd services to support ATS setup and configuration on Orange Pi companion computer.
NB: The Micro-XRCE-DDS agent, MAVLink router, and Zenoh bridge are deprecated and replaced by docker containers.

## Installation
1. Clone repository to home directory of orangepi user
`git clone https://github.com/mbrummelhuis/ats-setup`
2. Make script executable
`chmod u+x ~/ats-setup/scripts/<script_name>.sh`
3. Copy service files to systemd 
`sudo cp <service_name>.service /etc/systemd/system/<service_name>.service`
4. Reload systemd manager
`sudo systemctl daemon-reload`
5. Enable services start on boot
`sudo systemctl enable <service_name>.service`
6. Start services
`sudo systemctl start <service_name>.service`

## Features
### Network logging
To check if a network adapter goes up or down, see the logs at 
/var/log/network_events.log

To enable log rotation (manage logs so they don't grow indefinitely) using logrotate, copy the network_events file in configs to /etc/logrotate.d
`sudo cp configs/network_events /etc/logrotate.d/network_events`

You can test by forcing a log rotation with 
`sudo logrotate -f /etc/logrotate.d/network_events`