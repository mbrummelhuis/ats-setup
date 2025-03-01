#!/bin/bash
ip monitor link | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/network_events.log