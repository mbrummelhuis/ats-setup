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
---
### Network logging
Depends on moreutils
`sudo apt install moreutils`

Set up the service for network logging as instructed above.

To check if a network adapter goes up or down, see the logs at 
> /var/log/network_events.log

To enable log rotation (manage logs so they don't grow indefinitely) using logrotate, copy the network_events file in configs to /etc/logrotate.d
`sudo cp configs/network_events /etc/logrotate.d/network_events`

You can test by forcing a log rotation with 
`sudo logrotate -f /etc/logrotate.d/network_events`

### Time synchronization
The GCS and companion computer can be configured to synchronize time by setting up the GCS as a NTP (Network Time Protocol) server, and configuring the companion computer to get its time from the GCS. 
Depends on chrony on GCS and companion computer
`sudo apt install chrony`

On the *GCS*, configure /etc/chrony/chrony.conf to allow specific IPs to use the computer as NTP server
`allow 192.168.209.0/24`

On the *companion computer*, configure the chrony config to accept the GCS as NTP server (this must be a specific IP)
`server 192.168.209.xx iburst prefer`

Reload the chrony service to apply the config changes on both companion computer and GCS
`sudo systemctl restart chrony.service`

You can then verify that the right NTP source is used
`chronyc sources`

You can set the timezone of the companion computer to match the time zone of the GCS (Central European Time, CET) with
`sudo timedatectl set-timezone CET`
