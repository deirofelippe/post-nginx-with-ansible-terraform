clear-and-init: clear init

clear: container-remove-all

# init: container-init-compose ansible-run
init: container-init-compose ssh-config ansible-run

container-init:
	@docker container run -d --name test -p 3000:80 rastasheep/ubuntu-sshd:18.04

container-init-compose:
	@docker compose up -d

container-start:
	@docker container start test

container-get-ip:
	@echo -n "App 1 "
	@docker container inspect app1 -f '{{json .NetworkSettings.Networks.tutorial_loadbalancer.IPAddress}}'
	@echo -n "App 2 "
	@docker container inspect app2 -f '{{json .NetworkSettings.Networks.tutorial_loadbalancer.IPAddress}}'

container-list:
	@docker container ls -a
	
container-remove-all:
	@docker container rm -f $$(docker container ls -a -q)

ssh-open-container-nginx:
	@ssh root@10.0.1.1

ssh-open-container1:
	@ssh root@10.0.1.2

ssh-open-container2:
	@ssh root@10.0.1.3

ssh-start-app:
	@ssh root@10.0.1.2 "cd /node && npm start"

ssh-config: ssh-config-webserver

ssh-config-nginx:
	@ssh-copy-id -i ~/.ssh/ansible-test.pub root@10.0.1.1

ssh-config-webserver:
	@ssh-copy-id -i ~/.ssh/ansible-test.pub root@10.0.1.2
	@ssh-copy-id -i ~/.ssh/ansible-test.pub root@10.0.1.3
	
ansible-run:
	@ansible-playbook -vv -i ansible/hosts ansible/main.yaml