#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

col=ex-pets

## Create the collection (remove if exists)
fin collection delete -f $col
fin collection create $col ../example_1-pets.ttl

fin cd /collection/$col
## Add a thumbnail
#fin http put -@ thumbnail.png -P b thumbnail
#fin http patch -@ /dev/stdin <<< 'prefix s: <http://schema.org/> insert {<> s:thumbnail <$col/thumbnail> } WHERE {}' -P h

fin collection relation add-container $col pets -T part

cd pets
for file in *.jpg
do
  fin collection resource add -t ImageObject -m $file.ttl $col $file pets/$file
 done

cd ..
fin cd ..

fin collection resource add $col -H "Content-Type: application/octet-stream" ./wiki.hdt wiki-graph

fin collection relation add-properties $col http://schema.org/workExample pets/mochi.jpg http://schema.org/exampleOfWork

fin collection relation add-properties $col http://digital.ucdavis.edu/schema#hasGraph wiki-graph http://digital.ucdavis.edu/schema#isGraph
