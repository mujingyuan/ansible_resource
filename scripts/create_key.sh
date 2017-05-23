#!/bin/bash

key_dir=$(dirname $(readlink -f $0))"/../data/common/keys/"
environment=$1
project=$2
key_file=$key_dir/${project}_${environment}
if [ -f $key_file ]
then
    echo "the key ${key_file} is exist"
    exit 0
else
    ssh-keygen -t rsa -f $key_file -C "version publish for ${project} at ${environment}"
    if [ -f $key_file ]
    then
        echo "create key ${key_file} success"
    else
        echo "create key ${key_file} fail"
    fi
    exit 0
fi


