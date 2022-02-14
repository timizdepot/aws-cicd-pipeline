#!/bin/bash
# Install Ansible agent and python
apt update && apt full-upgrade -y
apt install ansible wget -y
apt install python-is-python3 python3-pip -y
pip3 install boto boto3 awscli