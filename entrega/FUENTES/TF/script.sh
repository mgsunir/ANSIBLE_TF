#!/bin/bash
export USER=ansible
export HOME_ANSIBLE=/home/${USER}

sudo useradd -m -s /bin/bash -g sudo ${USER} 
sudo usermod -aG sudo ${USER}
sudo echo "ansible:manolo88" | sudo chpasswd
#echo "$USER     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo apt-get update
sudo apt install python3-pip -y

sudo mkdir ${HOME_ANSIBLE}/.ssh
sudo chown ansible ${HOME_ANSIBLE}/.ssh
sudo cp /home/azureadmin/.ssh/authorized_keys  ${HOME_ANSIBLE}/.ssh/authorized_keys
sudo chown ${USER} ${HOME_ANSIBLE}/.ssh/authorized_keys
sudo chmod 0744 ${HOME_ANSIBLE}/.ssh/authorized_keys
sudo chmod 700 /home/ansible/.ssh

cat  /etc/sudoers | sed -e 's/\%sudo/\#\%sudo/g'> /etc/sudoers2; echo "%sudo   ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers2
mv /etc/sudoers2 /etc/sudoers



# ansible vm-azure -i ~/inventory.yaml -m shell -a "sudo apt-get update;sudo apt-get -y install podman" -b
# ansible vm-azure -i ~/inventory.yaml -m apt-get -a "name=podman state=present" -b
# ansible vm-azure -i ~/inventory.yaml -m containers.podman.podman_container -a "name=container  image= quay.io/bitnami/wildfly state=started"
# ansible vm-azure -i ~/inventory.yaml -m containers.podman.podman_container -a "name=container  image=quay.io/bitnami/wildfly state=started"


### Create a user with SSH login
# function create_ssh_user()
# {
#   local USER=$1
#   local SSH_PUBLIC_KEY=$2
#   local PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#   # create a user with a random password
#   useradd $USER -s /bin/bash -m
#   echo $USER:$PASSWORD | chpasswd

#   # add the user to the sudoers group so they can sudo
#   usermod -aG sudo $USER
#   echo "$USER     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#   # add the ssh public key
#   su - $USER -c "mkdir .ssh && echo $SSH_PUBLIC_KEY >> .ssh/authorized_keys && chmod 700 .ssh && chmod 600 .ssh/authorized_keys"
# }