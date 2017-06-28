#!/usr/bin/env bash
ansible_resource_dir=/data/www/ansible_handler/ansible_resource
environment=$1
project=$2
module=$3
targets=$4
inventory_file=${ansible_resource_dir}/data/inventory/${environment}/${project}
key_file=${ansible_resource_dir}/data/common/keys/${project}_${environment}
ansible --key-file=${key_file} --ssh-extra-args="-o StrictHostKeyChecking=no" --become  -i ${inventory_file} ${module} -m service -a "name=tomcat@${module} state=restarted"
