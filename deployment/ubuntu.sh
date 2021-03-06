#!/usr/bin/env bash

## Install basic development tools and nginx
sudo apt-get update
sudo apt-get install -y build-essential git nginx libkrb5-dev

## Install Databases
sudo apt-get install -y redis-server

## Install Node.js 4.x from NodeSource Distributions
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

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
