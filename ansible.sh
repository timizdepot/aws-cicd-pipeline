#!/bin/bash
# Install Ansible agent and python
yum update -y
yum install ansible wget unzip -y
amazon-linux-extras install ansible2
yum install python3 python3-pip -y
pip3 install boto boto3
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
useradd ansadmin
echo "ansadmin" | passwd --stdin ansadmin
systemctl enable sshd