#!/bin/bash

## Install basic development tools and nginx
sudo yum -y update
sudo yum -y groupinstall 'Development Tools'
sudo yum install -y openssl-devel
sudo yum install -y git

## Instalacion de nginx en CentOS

# Agregar el repositorio de Nginx para instalar con yum, crear el siguiente archivo: 
/etc/yum.repos.d/nginx.repo

# pegar en el archivo la sigiente configuracion:
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1

# Ejecutar la instalacion de Nginx
sudo yum install -y nginx

## Install Databases
sudo yum install -y redis

#instalacion de Node Version Manager
curl https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash

## Cerrar y abrir la terminal y ejecutar los siguientes comandos
nvm install 4.4.3
nvm use 4.4.3

#configuracion nginx
sudo /usr/sbin/setsebool httpd_can_network_connect true

## Configuracion de proxy con nginx a las intacias de Node.js
sudo cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bkp

# Editar el siguiente archivo
/etc/nginx/conf.d/default.conf

# Pegar la siente configuracion
upstream io_nodes {
  ip_hash;
  server 127.0.0.1:3000;
  server 127.0.0.1:3001;
  server 127.0.0.1:3002;
}

server {
  listen 8008;
  server_name host-name o ip-adress;
  location / {
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;
    proxy_http_version 1.1;
    proxy_pass http://io_nodes;
  }
}

# Editar las lineas del puerto y nombre del servidor en el archivo: default.conf
listen 8008;
server_name host-name o ip-adress;


# Instalar pm2 para administrar instancias de Node.js
npm install pm2 -g

# Crear el directorio mysqle y bajar la aplicacion
sudo mkdir /opt/mysqle

# Entrar al directorio /opt/mysqle y Clonar el repositorio del proyecto
cd /opt/mysqle
git clone https://github.com/jegutierrez/mysql-events.git package

# Dar permisos al usuario que va a ejecutar npm al directorio /opt/mysqle
sudo chown -R user /opt/mysqle

# Entrar al proyecto e instalar dependencias
cd package
npm install

# Crear el siguiente archivo
/opt/mysqle/pm2.json

# Pegar el contenido y configurar las instancias de la aplicacion
{
  "apps": [

    {
      "exec_mode": "fork_mode",
      "script": "/opt/mysqle/package/index.js",
      "name": "mysqle-1",
      "node_args": [],
      "env": {
        "PORT": 3000,
        "NODE_ENV": "production"
      },
      "error_file": "/opt/mysqle/logs/mysqle-1.err.log",
      "out_file": "/opt/mysqle/logs/mysqle-1.out.log"
    },
    {
      "exec_mode": "fork_mode",
      "script": "/opt/mysqle/package/index.js",
      "name": "mysqle-2",
      "node_args": [],
      "env": {
        "PORT": 3001,
        "NODE_ENV": "production"
      },
      "error_file": "/opt/mysqle/logs/mysqle-2.err.log",
      "out_file": "/opt/mysqle/logs/mysqle-2.out.log"
    },
    {
      "exec_mode": "fork_mode",
      "script": "/opt/mysqle/package/index.js",
      "name": "mysqle-3",
      "node_args": [],
      "env": {
        "PORT": 3002,
        "NODE_ENV": "production"
      },
      "error_file": "/opt/mysqle/logs/mysqle-3.err.log",
      "out_file": "/opt/mysqle/logs/mysqle-3.out.log"
    }
  ]
}

## Copy configuration to real destinations
sudo cp /root/config/default /etc/nginx/sites-enabled/default
sudo cp /root/config/pm2.json /opt/mysqle/

## Install MySQLe
sudo rm -rf /opt/mysqle
sudo mkdir -p /opt/mysqle
sudo tar xvfz /home/root/mysqle-1.0.0.tgz -C /opt/mysqle
cd /opt/mysqle/package && sudo npm install

## Run services
service nginx restart
