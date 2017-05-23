#!/usr/bin/env bash
ansible_resource_dir=/data/www/ansible_handler/ansible_resource
environment=$1
project=$2
module=$3
targets=$4
inventory_file=${ansible_resource_dir}/data/inventory/${environment}/${project}
playbook_file=${ansible_resource_dir}/${environment}/playbooks/${project}/${module}/deploy.yml
key_file=${ansible_resource_dir}/data/common/keys/${project}_${environment}
ansible-playbook --key-file=${key_file} --ssh-extra-args="-o StrictHostKeyChecking=no" -i ${inventory_file} --limit ${module} -e "targets=$targets module_name=${module}" ${playbook_file}