## Procedimiento para configurar entorno para deploy

# En la maquina que va a hacer deply generar un ssh_key
ssh-keygen -t rsa -C "your_email@youremail.com"

# Y luego copiar la llave ssh al server de destino
cat ~/.ssh/id_rsa.pub | ssh root@192.168.12.32 'cat >> ~/.ssh/authorized_keys'

# Ejecutar el script 'deploy.sh' y pasarle como parametro el host
./deply.sh 192.168.12.32