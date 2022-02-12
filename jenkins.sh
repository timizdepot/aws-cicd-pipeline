#!/bin/bash
apt update -y
apt full-upgrade -y
# download jenkins and run it using java jdk 11
add-apt-repository ppa:openjdk-r/ppa
apt install openjdk-11-jdk wget -y
wget https://updates.jenkins-ci.org/download/war/2.334/jenkins.war
cd /opt/
wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
tar -xvzf apache-maven-3.8.4-bin.tar.gz
rm -f apache-maven-3.8.4-bin.tar.gz
nohup java -jar jenkins.war &