#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

COLLECTION=example_6-library-3d

## Create the collection (remove if exists)
fin collection delete -f $COLLECTION
fin collection create $COLLECTION index.ttl

fin cd /collection/$COLLECTION

fin collection relation add-container $COLLECTION scenes -T part

for file in *.jpg
do
  id=`basename $file .jpg`;
  fin collection resource add -t ImageObject -m $file.ttl $COLLECTION ./$file scenes/$id
done

#fin collection relation add-properties example_1-pets http://schema.org/workExample pets/mochi http://schema.org/exampleOfWork
#fin collection relation add-properties example_1-pets http://digital.ucdavis.edu/schema#hasGraph wiki-graph http://digital.ucdavis.edu/schema#isGraph