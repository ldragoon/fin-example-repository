#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

## Create the collection (remove if exists)
fin collection delete -f example_1-cats
fin collection create example_1-cats index.ttl
fin collection relation add-container example_1-cats . -T part

## add all files in the eastman-example director using base filename as member id
for file in *.jpg
do
  id=`basename $file`;
  fin collection resource add example_1-cats $file $id $file.ttl
done

fin collection relation add-properties eastman-e http://schema.org/workExample http://schema.org/exampleOfWork ashley

fin collection acl group add \
  example_1-Cats admins rw \
  --agent quinn \
