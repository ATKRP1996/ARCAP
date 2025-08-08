#!/bin/bash
set -euo pipefail

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing OpenJDK 11..."
sudo apt install openjdk-11-jdk -y

echo "Downloading Jenkins GPG key..."
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package index and Installing Jenkins..."
sudo apt update
sudo apt-get install fontconfig openjdk-17-jre -y
sudo apt install jenkins -y

echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Configuring firewall to allow SSH and Jenkins (port 8080)..."
sudo ufw allow OpenSSH
sudo ufw allow 8080
sudo ufw --force enable
sudo ufw status

echo "Jenkins installation is complete!"
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#(if available): sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Password not yet generated. Check manually after a minute."
echo
echo "Access Jenkins at: http://<YOUR_VM_PUBLIC_IP_OR_HOSTNAME>:8080 (replace with your VM's IP or hostname)"
