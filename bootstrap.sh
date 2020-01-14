#!/usr/bin/env bash

PROJECT_NAME="$1"
PROJECT_IP="$2"
PROJECT_ROOT="/home/project/databases"
PROJECT_TLD="test"

echo " = = = "
echo " PROJECT_NAME= ${PROJECT_NAME}"
echo " PROJECT_ROOT= ${PROJECT_ROOT}"
echo " = = = "

function setup_dockerhub {
	if [ ! -z "$VM_DOCKERHUB_LOGIN" ] && [ ! -z "$VM_DOCKERHUB_PASSWORD" ]; then
		local HASH="$(echo "${VM_DOCKERHUB_LOGIN}:${VM_DOCKERHUB_PASSWORD}" | base64)"

		sed -ri \
			-e 's/^(VM_DOCKERHUB_LOGIN=).+$/\1""/' \
			-e 's/^(VM_DOCKERHUB_PASSWORD=).+$/\1""/' \
			-e '/^VM_DOCKERHUB_HASH.+$/d' \
		/vagrant/vm.cfg

		echo "VM_DOCKERHUB_HASH='$HASH'" >> /vagrant/vm.cfg
	else
		if [ ! -z "$VM_DOCKERHUB_HASH" ]; then
			VM_DOCKERHUB_LOGIN="$(echo "$VM_DOCKERHUB_HASH" | base64 -d | cut -d ":" -f 1)"
			VM_DOCKERHUB_PASSWORD="$(echo "$VM_DOCKERHUB_HASH" | base64 -d | cut -d ":" -f 2-)"
		fi
	fi

	if [ ! -z "$VM_DOCKERHUB_LOGIN" ] && [ ! -z "$VM_DOCKERHUB_PASSWORD" ]; then
		echo 'Found Docker hub login info, setting up ... '
        if ! sudo -u project docker login -u "$VM_DOCKERHUB_LOGIN" -p "$VM_DOCKERHUB_PASSWORD" &> /dev/null; then
            echo -e "\033[0;31mERROR: Login failed, skipping dockerhub setup!\033[0m"
        fi
	fi
}

function save_config_variables {
    if [ -f /vagrant/vm.cfg ]; then
		echo 'saving vm.cfg into environment'
        cat /vagrant/vm.cfg >> /etc/environment
    fi
}

setup_dockerhub
save_config_variables

sudo -u project mkdir -p $PROJECT_ROOT

echo 'Configure unison server'
sed -i 's~UNISON_SERVER_PATH=~UNISON_SERVER_PATH=/home/project/databases~' /etc/unison/server.conf

# make directories not that dark on dark background
echo 'DIR 30;47' > /home/project/.dircolors
chown project:project /home/project/.dircolors

cd $PROJECT_ROOT

cp -a /vagrant/databases ./
rm -rf '/home/project/projects'

echo -e "\n## Update local /etc/hosts ...\n"
echo "${PROJECT_IP}            ${PROJECT_NAME}.${PROJECT_TLD}" | sudo tee -a /etc/hosts
