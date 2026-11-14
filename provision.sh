#!/bin/bash
set -e

apt-get update
apt-get install -y wget curl gnupg ca-certificates

install -d -m 0755 /etc/apt/keyrings
wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public \
  | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg

echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb noble main" \
  > /etc/apt/sources.list.d/adoptium.list

apt-get update
apt-get install -y temurin-8-jdk

cd /opt
wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz
tar -xzf apache-tomcat-9.0.98.tar.gz
mv apache-tomcat-9.0.98 tomcat9
sed -i 's/port="8080"/port="7070"/' /opt/tomcat9/conf/server.xml
chmod +x /opt/tomcat9/bin/*.sh

/opt/tomcat9/bin/startup.sh
