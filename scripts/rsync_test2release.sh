#!/usr/bin/env bash
project=$1
script_dir=`pwd`
echo $script_dir
release_dir="${script_dir}/../release"
test_dir="${script_dir}/../test"

for dir in playbooks scripts
do
  rsync -av ${test_dir}/$dir/$project/ ${release_dir}/$dir/$project/
done

