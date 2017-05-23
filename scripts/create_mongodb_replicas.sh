#!/usr/bin/env bash
ansible_resource_dir=/data/www/ansible_handler/ansible_resource
environment=$1
project=$2
mongodb_master_target=$3
mongodb_replicas_target=$4
inventory_file=${ansible_resource_dir}/data/inventory/${environment}/${project}
playbook_file=${ansible_resource_dir}/playbooks/deploy_mongodb.yml
key_file=${ansible_resource_dir}/data/common/keys/${project}_${environment}
ansible-playbook --key-file=${key_file} --ssh-extra-args="-o StrictHostKeyChecking=no" -i ${inventory_file} -e "mongodb_master_target=$mongodb_master_target mongodb_replicas_target=$mongodb_replicas_target project=$project" ${playbook_file}