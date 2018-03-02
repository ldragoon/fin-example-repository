#! /bin/bash

# FIN='node ../fin-cli/lib'
FIN=fin

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

## Create the collection (remove if exists)
$FIN collection delete -f eastman-example
$FIN collection create eastman-example ./collection/eastman-example/index.ttl
$FIN collection relation add-container eastman-example members -T part

## add all files in the eastman-example director using base filename as member id
for file in ./collection/eastman-example/*
do
  if [[ -f $file && $file =~ tif$ ]]; then
    # strip file path and ext for member id
    id=$(basename "$file")
    id="${id%.*}"

    $FIN collection resource add eastman-example $file members/$id -t CreativeWork
  fi
done

$FIN collection relation add-properties eastman-example \
  http://schema.org/exampleOfWork members/B-10006 \
  http://schema.org/workExample

$FIN collection acl group add \
  eastman-example admins rw \
  --agent jrmerz@ucdavis.edu \
  --agent qjhart@ucdavis.edu \
  --agent xioalili@ucdavis.edu 
