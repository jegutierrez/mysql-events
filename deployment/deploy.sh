
#!/usr/bin/env bash

npm pack ../
scp ./mysqle-1.0.0.tgz root@$1:~
scp -r ./config root@$1:~
scp ./centos.sh root@$1:~
ssh -t root@$1 "sudo bash ~/centos.sh"
