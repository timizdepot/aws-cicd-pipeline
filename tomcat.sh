#!/bin/bash
yum update -y
yum install java-11-openjdk.x86_64 wget -y
cd /opt/
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz
tar -xvzf apache-tomcat-10.0.16.tar.gz
rm -f apache-tomcat-10.0.16.tar.gz
cd apache-tomcat-10.0.16/bin/
chmod +x startup.sh shutdown.sh
ln -s /opt/apache-tomcat-10.0.16/bin/startup.sh /usr/bin/tomcatup
ln -s /opt/apache-tomcat-10.0.16/bin/shutdown.sh /usr/bin/tomcatdown
