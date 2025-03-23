#!/bin/bash
export HOME_DIR=/home/terraform/TF/TF3
export DEST_USR_GROUP=ansible:ansible
export DIR_DEST=/home/ansible
export DIR_DEST_ANSIBLE=${DIR_DEST}/ANSIBLE

cd ${HOME_DIR}
cp variables_general.yaml          ${DIR_DEST_ANSIBLE}/variables_general_local.yaml
cp *.yaml                          ${DIR_DEST_ANSIBLE}
ls -la ${DIR_DEST_ANSIBLE}/*.yaml
cp variables_general.yaml          ${DIR_DEST_ANSIBLE}/ROLE_AKS/vars
#cp variables_general.yaml          ${DIR_DEST_ANSIBLE}/ROLE_LOCAL/vars
cp variables_general.yaml          ${DIR_DEST_ANSIBLE}/ROLE_LOCAL/vars/variables_general_local.yaml
cp variables_acr.yaml              ${DIR_DEST_ANSIBLE}/ROLE_AKS/vars
cp variables_acr.yaml              ${DIR_DEST_ANSIBLE}/ROLE_LOCAL/vars

if [ ! -d ${DIR_DEST}  ]
then
  mkdir  ${DIR_DEST}/.kube
fi

cp /home/terraform/.kube/config      ${DIR_DEST}/.kube/config

chown -R ${DEST_USR_GROUP}         ${DIR_DEST}/.kube
chown  ${DEST_USR_GROUP}         ${DIR_DEST_ANSIBLE}/variables_general_local.yaml
chown  ${DEST_USR_GROUP}         ${DIR_DEST_ANSIBLE}/ROLE_AKS/vars/variables_general.yaml
chown  ${DEST_USR_GROUP}         ${DIR_DEST_ANSIBLE}/ROLE_LOCAL/vars/variables_general.yaml
chown  ${DEST_USR_GROUP}         ${DIR_DEST_ANSIBLE}/ROLE_AKS/vars/variables_acr.yaml
chown  ${DEST_USR_GROUP}         ${DIR_DEST_ANSIBLE}/ROLE_LOCAL/vars/variables_acr.yaml
