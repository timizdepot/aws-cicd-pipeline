#!/bin/bash
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
useradd ansadmin
echo "ansadmin" | passwd --stdin ansadmin
systemctl enable sshd
# Install Ansible agent and python
apt update && apt full-upgrade -y
apt install -y ansible
apt install python-is-python3 python3-pip -y
pip3 install boto boto3 awscli
