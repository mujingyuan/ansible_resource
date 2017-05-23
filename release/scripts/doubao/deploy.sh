#!/bin/bash
version=$1
file_name=$2
zipfile=/home/admin/release/tmp/${version}/${file_name}
function check ()  {
    if [ $? -ne 0 ];then
        exit 1
    fi
}

function check_file(){
if [ ! -f "${zipfile}" ]; then
        echo "can not find file ${zipfile}"
        exit 1
fi

}

function production_prepare(){
mkdir -p /home/admin/release/${version}
rm /home/admin/release/${version}/* -rf
unzip ${zipfile} -d /home/admin/release/${version}
rsync -av /home/admin/conf/default/ /home/admin/release/${version}/config/
}

function production_update(){
pm2 stop app
pm2 delete app
rm /home/admin/app-run -rf
ln -s /home/admin/release/${version} /home/admin/app-run

cd /home/admin/app-run && pm2 start app.js
}

function production_check(){

prod_status=`pm2 status| grep app | sed -n 1p | awk '{print $10}'`

if [ "x${prod_status}" == "xonline" ];then
    echo done
    exit 0
else
    echo fail
    exit 1
fi
}
check_file
production_prepare
production_update
production_check