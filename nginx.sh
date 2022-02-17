#!/bin/bash
apt update && apt full-upgrade -y
apt install nginx -y
systemctl start nginx && systemctl enable nginx
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
useradd nginxadmin
echo "nginxadmin" | passwd --stdin nginxadmin