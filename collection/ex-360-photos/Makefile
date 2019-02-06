#!/usr/bin/make -f
SHELL:=/bin/bash

c:=fin collection

col:=ex-360-photos

photos:=$(wildcard photos/* )
ttl:=$(patsubst %,%/metadata.ttl,${photos})
ldp:=$(patsubst %,%/ldp.ttl,${photos})

schema:=http://schema.org

ex:=tin

INFO:
	echo photos: ${photos}

.PHONY: ldp

ldp: new-collection.ttl ${ldp} ldp.ttl

new-collection.ttl: agents:= quinn enebeker jrmerz
new-collection.ttl: schema:=http://www.schema.org
new-collection.ttl: index.ttl
	$c delete -f ${col};\
	$c create ${col} index.ttl;\
  $c acl group add ${col} admins rw $(patsubst %,--agent %@ucdavis.edu,${agents});\
  $c relation add-container ${col} photos -T part;
	fin http get -P b /collection/${col} > $@

add-workExample: schema:=http://www.schema.org
add-workExample:
	fin http patch --data-string "PREFIX s: <http://schema.org/> PREFIX ldp: <http://www.w3.org/ns/ldp#> INSERT {<>  s:image  <${col}/photos/${ex}/media/images/TeaTin-Test360-01> . } WHERE {} " /collection/${col}

ldp.ttl: add-workExample
	fin http get -P b /collection/${col} > $@

${ldp}:%/ldp.ttl:%/metadata.ttl
	$c resource delete ${col} photos/$(notdir $*);\
	$c resource add ${col} $< photos/$(notdir $*);\
	$c relation add-container -T media ${col} photos/$(notdir $*)/media;\
	$c resource add --type MediaObject ${col} image_list.ttl photos/$(notdir $*)/media/images;\
  fin http patch --data-string "PREFIX s: <http://schema.org/> PREFIX ldp: <http://www.w3.org/ns/ldp#> INSERT {<> ldp:hasMemberRelation s:hasPart ; ldp:isMemberOfRelation s:partOf; ldp:membershipResource <>. } WHERE {} " /collection/${col}/photos/$(notdir $*)/media/images ;\
  for f in $*/media/images/*.jpg; do \
    b=$$(basename $$f .jpg);\
    p=$${b#*-*-};\
    $c resource add --type MediaObject ${col} $$f photos/$(notdir $*)/media/images/$$b;\
    ins="INSERT {<> <http://schema.org/position>  \"$$p\" } WHERE {}";\
    fin http patch --data-string "$$ins" /collection/${col}/photos/$(notdir $*)/media/images/$$b/fcr:metadata ;\
  done;\
	fin http get -P b /collection/${col}/photos/$(notdir $*) > $@

clean:
	@rm -f ldp.ttl ${ldp}
	@rm -f new-collection.ttl