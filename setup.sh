#!/bin/bash

#This is a simple script that automates the installation of docker and minikube on Ubuntu machines
#System Requirements 
#RAM: At least 2GB
#Processor: A CPU with at least 2 vCores
#Storage: At least 20GB of storage

#Install docker
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#install essentials
sudo apt install curl build-essential git screen jq pkg-config libssl-dev libclang-dev ca-certificates gnupg lsb-release -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

git clone https://github.com/conduitxyz/node.git

#dockergroup check function
dockergroupcheck() {
    if [[ $(getent group docker) ]]; then
      echo "docker group found!"
      echo "Adding user to docker group..."
      sudo usermod -aG docker $USER && echo "${USER} has been added to docker group" && newgrp docker
    else
      echo "No docker group found!"
      echo "Attempting to create docker group..."
      sudo groupadd docker && sudo usermod -aG docker $USER && echo "${USER} has been added to docker group" && newgrp docker
    fi
}

#checks if USER variable is empty. Useful if script is going to be used as a startup script
#e.g. Userdata for EC2-Instance
echo "Checking \$USER variable and adding to docker group....."
[[ -z "$USER" ]] && USER="ubuntu" && dockergroupcheck || dockergroupcheck
