#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source $DIR/../../fin_shims.sh

# The collection is the directory name
collection=`basename $DIR`

## Create the collection (remove if exists)
fin cd /collection
fin collection delete -f ${collection}
fin_collection_create ${collection} index.ttl
# Anyone can read
fin collection acl user add $collection foaf:Agent r
# Admins can write
fin collection acl group add \
  $collection admins rw \
  --agent jrmerz@ucdavis.edu \
  --agent qjhart@ucdavis.edu \
  --agent xioalili@ucdavis.edu


## add all files in the eastman-example director using base filename as member id
for d in `find * -maxdepth 0 -type d`;
do
  # Make a directory, any items in subsequent directories are items
  fin_mkdir --hasMember=:hasPart --isMemberOf=:isPartOf --resource="/collection/${collection}" /collection/${collection}/${d}
  for photo in `find $d -name index.ttl`;
  do
    d=$(dirname $photo);
    id=$(basename $d);
    fin_mkdir /collection/$collection/$d --file=$photo
    fin_mkdir --hasMember=:associatedMedia --isMemberOf=:encodesCreativeWork --resource="/collection/${collection}/$d" /collection/${collection}/${d}/media
    for media in $d/media/*; do
      n=`basename $media .tif`
      mime=`file --mime-type -b $media`;
      fin_media_add --file=$media --ttl="<> a s:MediaObject; s:encodingFormat \"$mime\"; s:name \"$n\"." "/collection/${collection}/${d}/media/$n"
    done
  done
done
