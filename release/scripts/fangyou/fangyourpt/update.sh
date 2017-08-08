#!/bin/bash

env=$1
project=$2
module=$3
version=$4
build=$5

log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" >> ${log_file}

latest_dir="/home/admin/publish/${project}/${module}/lastest/code"
webapps_dir="/usr/local/${module}"

# jar_file_name="fangyourpt_v0.0.1_release_1.jar"
jar_file_name=${module}_${version}_${build}_${env}.jar
real_module="fangyourpt"

check_is_not_root () 
{
current_dir=`pwd`
if [ "${current_dir}#" == "/#" ] ; then
    echo "try to remove root" >>  ${log_file}
    exit 1
fi
}

deploy_new_version ()
{
if [ -d ${webapps_dir} -a -f ${latest_dir}/${jar_file_name} ] ; then
    echo "deploy jar file" >> ${log_file}
    echo "${latest_dir}/${jar_file_name}" >> ${log_file}
    echo "${webapps_dir}/${jar_file_name}" >> ${log_file}
    cp -f ${latest_dir}/${jar_file_name} ${webapps_dir}/${real_module}.jar
    cd ${webapps_dir}

else
    echo "webapps_dir or jar_file is None" >> ${log_file}
fi
}

check_version ()
{
  if [ -f ${webapps_dir}/${real_module}.jar ]; then
    echo "update success" >> ${log_file}
    echo "${version}_${build}" >  ${webapps_dir}/VERSION
    exit 0
  else
    echo "update fail" >> ${log_file}
    exit 1
  fi
}

check_is_not_root
deploy_new_version
check_version