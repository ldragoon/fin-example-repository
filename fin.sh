#! /bin/bash

FIN='node ../fin-cli/lib'

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

## Create the collection (remove if exists)
fin collection delete -f eastman-example
fin collection create eastman-example ./collection/eastman-example/index.ttl

## add all files in the eastman-example director using base filename as member id
for file in ./collection/eastman-example/*
do
  if [[ -f $file && $file =~ tif$ ]]; then
    # strip file path and ext for member id
    id=$(basename "$file")
    id="${id%.*}"

    fin collection member add eastman-example $file $id
  fi
done

fin collection acl group add \
  eastman-example admins rw \
  --agent jrmerz@ucdavis.edu \
  --agent qjhart@ucdavis.edu \
  --agent xioalili@ucdavis.edu 
