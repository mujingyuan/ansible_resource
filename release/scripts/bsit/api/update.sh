#!/usr/bin/env bash
env=$1
project=$2
module=$3
version=$4
build=$5
log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" > ${log_file}

base_dir="/home/admin/publish"
latest_config_dir="${base_dir}/${project}/${module}/lastest/conf"
latest_code_dir="${base_dir}/${project}/${module}/lastest/code"
module_dir="/opt/app/${module}"

deploy_new_version ()
{
    rsync -av ${latest_code_dir}/ ${module_dir}/ >> ${log_file}
}


mark_version ()
{
    echo "${version}_${build}" >  ${module_dir}/VERSION
}

deploy_new_version
mark_version
