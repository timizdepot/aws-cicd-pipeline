#!/bin/bash
# Install Ansible agent and python
yum update -y
yum install ansible wget -y
amazon-linux-extras install ansible2
yum install python-is-python3 python3-pip -y
pip3 install boto boto3 awscli -y

sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
useradd ansadmin
echo "ansadmin" | passwd --stdin ansadmin
systemctl enable sshd