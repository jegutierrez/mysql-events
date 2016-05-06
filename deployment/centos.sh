#!/bin/bash

## Install basic development tools and nginx
sudo yum -y update
sudo yum -y groupinstall 'Development Tools'
sudo yum install -y gcc gcc-c++ make openssl-devel git nginx libkrb5-dev

## Install Databases
sudo yum install -y redis

## Install Node.js 4.x from NodeSource Distributions
sudo yum install -y nodejs
curl https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash

## Close and reopen terminal
nvm install 4.*.*
nvm use 4.*

## Copy configuration to real destinations
sudo cp /home/root/config/default /etc/nginx/sites-enabled/default
sudo cp /home/root/config/mysqle-1.conf /etc/init
sudo cp /home/root/config/mysqle-2.conf /etc/init
sudo cp /home/root/config/mysqle-3.conf /etc/init

## Install MySQLe
sudo rm -rf /opt/mysqle
sudo mkdir -p /opt/mysqle
sudo tar xvfz /home/root/mysqle-1.0.0.tgz -C /opt/mysqle
cd /opt/mysqle/package && sudo npm install

## Run services
service nginx restart
service mysqle-1 restart
service mysqle-2 restart
service mysqle-3 restart
