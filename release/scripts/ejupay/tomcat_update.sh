#!/bin/bash

env=$1
project=$2
module=$3
version=$4
build=$5

declare -A war_dic
war_dic=(
    [pointin]="points-inrpc"
    [mbin]="mb-inrpc"
    [infoin]="info-inrpc"
    [gwin]="gateway-inrpc"
    [billin]="bill-inrpc"
    [gwmock]="gateway-mock"
    [accesspos]="access-pos"
    [accessout]="access-out"
    [msg2in]="msg2-inrpc"
    [channelout]="channel-outrpc"
    [channelin]="channel-inrpc"
    [cashin]="cash-inrpc"
    [activityin]="activity-inrpc"
    [monitorin]="monitor-inrpc"
    [gwout]="gateway-outrpc"
    [consoleout]="console-outrpc"
    [accessposfangjs]="access-posfangjs"
    [timerin]="timer-inrpc"
    [accountin]="account-inrpc"
    [querycontrol]="query-control"
    [kabinin]="kabin-inrpc"
    [consolein]="console-inrpc"
    [clearingin]="clearing-inrpc"
    )

real_module=${war_dic[$module]}
log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" > ${log_file}

latest_dir="/home/admin/publish/${project}/${module}/lastest"


# war_file_name="mb-inprc_v1.6.16_test_45.war"
war_file_name=${module}_${version}_${env}_${build}.war
# app_config_name="mb-inprc_v1.6.16_test_45_config.zip"
app_config_name=${module}_${version}_${env}_${build}_config.zip

declare -A config_dic
config_dic=(
    [pointin]="points"
    [mbin]="mb"
    [infoin]="info"
    [gwin]="gateway"
    [billin]="bill"
    [gwmock]="gateway"
    [accesspos]="access"
    [accessout]="access"
    [msg2in]="msg2"
    [channelout]="channel"
    [channelin]="channel"
    [cashin]="cash"
    [activityin]="activity"
    [monitorin]="monitor"
    [gwout]="gateway"
    [consoleout]="console"
    [accessposfangjs]="access"
    [timerin]="timer"
    [accountin]="account"
    [querycontrol]="query"
    [kabinin]="kabin"
    [consolein]="console"
    [clearingin]="clearing"
    )
module_app_config=${config_dic[$module]}
app_config_dir="/opt/app_config/"${module_app_config}
module_dir="/opt/tomcat/${module}"
webapps_dir=${module_dir}"/webapps"

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
if [ -d ${app_config_dir} -a -f ${latest_dir}/${app_config_name} ] ; then
    echo "delete app config files" >> ${log_file}
    cd ${app_config_dir}
    # ehcache-hibernate.xml
    # logback.xml
    # sc_mb.properties
    check_is_not_root
    rm -f *.xml
    rm -f *.properties
else
   echo "app config or app config dir is None" >> ${log_file}
fi

# /opt/tomcat/mb-inprc/webapps/
if [ -d ${webapps_dir} -a -f ${latest_dir}/${war_file_name} ] ; then
    echo "delete app war and dir" >> ${log_file}
    cd ${webapps_dir}
    check_is_not_root
    echo ${real_module} >> ${log_file}
    if [ "${real_module}##" != "##" ]
    then
        rm -f ./${real_module}.war
        rm -rf ./${real_module}
    else
        echo "realmodule is null" >> ${log_file}
        exit 1
    fi
else
    echo "webapps_dir or war_file is None" >> ${log_file}
fi
}

deploy_new_version ()
{
if [ -d ${app_config_dir} -a -f ${latest_dir}/${app_config_name} ] ; then
    echo "deploy app config" >> $log_file
    cd ${app_config_dir}
    unzip -o ${latest_dir}/${app_config_name} >> ${log_file}
else
    echo "app config or app config dir is None" >> ${log_file}
fi

if [ -d ${webapps_dir} -a -f ${latest_dir}/${war_file_name} ] ; then
    echo "deploy war file" >> ${log_file}
    echo "${latest_dir}/${war_file_name}" >> ${log_file}
    echo "${webapps_dir}/${real_module}.war" >> ${log_file}
    cp ${latest_dir}/${war_file_name} ${webapps_dir}/${real_module}.war
else
    echo "webapps_dir or war_file is None" >> ${log_file}
fi
}

check_version ()
{
  if [ -f ${webapps_dir}/${real_module}.war ]; then
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
