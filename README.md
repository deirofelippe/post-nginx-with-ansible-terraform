docker container ls -a
docker container rm -f $(docker container ls -a -q)
docker container run -d --name test -p 3000:80 rastasheep/ubuntu-sshd:18.04
docker container inspect test -f '{{json .NetworkSettings.IPAddress}}'
ssh-keygen -t rsa -f ~/.ssh/ansible-test
ssh-copy-id -i ~/.ssh/ansible-test.pub root@172.17.0.2

ansible-playbook -i hosts main.yaml

##

ssh
nodejs
npm install
pm2
sobe ou da git clone?

ansible inventario dinamico

make clear-and-config
make clear
make init
senha ssh: root

app.127.0.0.1.nip.io:3000

apt update -y && \
apt upgrade && \
apt install -y openssh-server ufw && \
service ssh start && \
service ssh status && \
ufw enable
ufw status
ufw allow 22/tcp
