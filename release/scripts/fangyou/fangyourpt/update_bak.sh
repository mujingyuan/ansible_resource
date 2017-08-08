#!/bin/bash

env=$1
project=$2
module=$3
version=$4
build=$5

log_file=/tmp/${module}_${version}_${build}_update.log
echo "update script start" >> ${log_file}

latest_dir="/home/admin/publish/${project}/${module}/lastest"
webapps_dir="/usr/local/fangyourpt"

# jar_file_name="fangyourpt_v0.0.1_release_1.jar"
jar_file_name=${module}_${version}_${env}_${build}.jar

process_pid=`ps aux|grep fangyourpt|grep -v "grep"|grep jar|awk '{print $2}'`
process_nu=`ps aux|grep fangyourpt|grep -v "grep"|grep jar|awk '{print $2}'|wc -l`

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
    cp -f ${latest_dir}/${jar_file_name} ${webapps_dir}/${jar_file_name}
    cd ${webapps_dir}

####
if [[ $process_nu -eq 1 ]];then

        kill ${process_pid}
        sleep 15
                kill -9 ${process_pid}
                kill -9 ${process_pid}
        nohup /usr/local/jdk1.8.0_60/bin/java -jar ${jar_file_name} > nohup.out &
        echo "${jar_file_name} restart ok" >> ${log_file}
else
        nohup /usr/local/jdk1.8.0_60/bin/java -jar ${jar_file_name} > nohup.out &
        echo "${jar_file_name} is not running and start" >> ${log_file}
fi
####

else
    echo "webapps_dir or jar_file is None" >> ${log_file}
fi
}

check_is_not_root
deploy_new_version