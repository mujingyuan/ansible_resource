#!/usr/bin/env bash
env=$1
project=$2
module=$3
version=$4
build=$5
log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" > ${log_file}

base_dir="/home/admin/publish"
latest_dir="${base_dir}/${project}/${module}/lastest/code"
jar_file_name=${project}${module}_${version}_${build}_${env}.jar
latest_version_file="${latest_dir}/${jar_file_name}"
latest_config_dir="${base_dir}/${project}/${module}/lastest/conf"
module_dir="/opt/app/${module}"
real_module="${module}.jar"

clean_pre_version ()
{
# /opt/app/runner/
if [ -d ${module_dir} -a -f ${latest_version_file} ] ; then
    echo "delete app war and dir" >> ${log_file}
    echo ${real_module} >> ${log_file}
    if [ "${real_module}##" != "/##" ]
    then
        cd ${module_dir}
        rm -f ${real_module}
    else
        echo "realmodule is /" >> ${log_file}
        exit 1
    fi
else
    echo "module dir or latest version file is None" >> ${log_file}
fi
}

deploy_new_version ()
{
    cp ${latest_version_file} ${module_dir}/${real_module} >> ${log_file}
    if [ -f ${latest_config_dir}/logback-spring.xml ]
    then
        rsync -av ${latest_config_dir}/logback-spring.xml ${module_dir}/logback-spring.xml
    fi
    rsync -av ${latest_config_dir}/config/ ${module_dir}/config/ >> ${log_file}
}


mark_version ()
{
    echo "${version}_${build}" >  ${module_dir}/VERSION
}


clean_pre_version
deploy_new_version
mark_version
