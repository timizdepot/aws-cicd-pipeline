#!/bin/bash
yum update -y
yum install java-11-openjdk.x86_64 wget -y
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz