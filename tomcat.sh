#!/bin/bash
yum update -y
yum install java-11-openjdk.x86_64 wget -y
cd /opt/
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.58/bin/apache-tomcat-9.0.58.tar.gz
tar -xvzf apache-tomcat-9.0.58.tar.gz
rm -f apache-tomcat-9.0.58.tar.gz
cd apache-tomcat-9.0.58/bin/
chmod +x startup.sh shutdown.sh
ln -s /opt/apache-tomcat-9.0.58/bin/startup.sh /usr/bin/tomcatup
ln -s /opt/apache-tomcat-9.0.58/bin/shutdown.sh /usr/bin/tomcatdown

sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
useradd ansadmin
echo "ansadmin" | passwd --stdin ansadmin
systemctl enable sshd