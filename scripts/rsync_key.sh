#!/usr/bin/env bash
ansible_resource_dir=/data/www/ansible_handler/ansible_resource
environment=$1
project=$2
targets=$3
inventory_file=${ansible_resource_dir}/data/inventory/$environment/$project
playbook_file=${ansible_resource_dir}/playbooks/create_admin_by_ldap.yml
cover_key="yes"
new_publick_key=""
ansible-playbook -k --ssh-extra-args="-o StrictHostKeyChecking=no" -i ${inventory_file} -e "targets=$targets project=$project env=$environment ansible_resource_dir=$ansible_resource_dir cover_key=${cover_key} new_publish_key=${new_publick_key}" ${playbook_file}