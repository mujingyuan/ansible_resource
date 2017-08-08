#!/bin/bash

env=$1
project=$2
module=$3
version=$4
build=$5
real_module="inrpc-release"
log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" > ${log_file}

latest_config_dir="/home/admin/publish/${project}/${module}/lastest/conf"
latest_code_dir="/home/admin/publish/${project}/${module}/lastest/code"


# war_file_name="mb-inprc_v1.6.16_test_45.war"
jar_file_name=${project}${module}_${version}_${build}_${env}.jar
module_dir="/opt/app/${module}"

check_is_not_root ()
{
current_dir=`pwd`
if [ "${current_dir}#" == "/#" ] ; then
    echo "try to remove root" >>  ${log_file}
    exit 1
fi
}


clean_pre_version ()
{
if [ -d ${module_dir} -a -f ${latest_code_dir}/${jar_file_name} ] ; then
    echo "delete app jar and dir" >> ${log_file}
    cd ${module_dir}
    check_is_not_root
    echo ${real_module} >> ${log_file}
    if [ "${real_module}##" != "##" ]
    then
        rm -f ./${real_module}.jar
    else
        echo "realmodule is null" >> ${log_file}
        exit 1
    fi
else
    echo "module_dir or jar_file is None" >> ${log_file}
fi
}

deploy_new_version ()
{
if [ -d ${module_dir} -a -f ${latest_code_dir}/${jar_file_name} ] ; then
    echo "deploy jar file" >> ${log_file}
    echo "${latest_code_dir}/${jar_file_name}" >> ${log_file}
    echo "${module_dir}/${real_module}.jar" >> ${log_file}
    cp ${latest_code_dir}/${jar_file_name} ${module_dir}/${real_module}.jar
else
    echo "module_dir or jar_file is None" >> ${log_file}
fi
}

check_version ()
{
  if [ -f ${module_dir}/${real_module}.jar ]; then
    echo "update success" >> ${log_file}
    echo "${version}_${build}" >  ${module_dir}/VERSION
    exit 0
  else
    echo "update fail" >> ${log_file}
    exit 1
  fi
}

clean_pre_version 
deploy_new_version
check_version
