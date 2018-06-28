#!/usr/bin/make -f
SHELL:=/bin/bash

c:=fin collection

col:=example_4-wine-labels

labels:=$(shell find folder -type d -name label_\*)
ldp:=$(patsubst %,%/ldp.ttl,${labels})

.PHONY: add-collection ldp
ldp:add-collection ${ldp} ldp.ttl

#index.ttl: index.ttl.in
#	node link_list.js > $@

add-collection: agents:= quinn enebeker jrmerz
add-collection: schema:=http://www.schema.org
add-collection: index.ttl
	$c delete -f ${col};\
	$c create ${col} index.ttl;\
  $c acl group add ${col} admins rw $(patsubst %,--agent %@ucdavis.edu,${agents});\
  $c relation add-container ${col} labels -T part;

ldp.ttl:
	$c relation add-properties ${col} ${schema}/workExample labels/label_0374/media/0374 ${schema}/exampleOfWork; \
	fin http get -P b /$collection/${col} > $@

define indexable
  fin http patch --data-string "INSERT {<> <http://digital.ucdavis.edu/schema#textIndexable> true . } WHERE {}" -P h /collection/$1/$2/fcr:metadata
endef

#	  $c resource add --type MediaObject ${col} $*/google-vision.json labels/$(notdir $*)/media/google-vision; \

${ldp}:%/ldp.ttl:%/metadata.ttl
	$c resource delete ${col} labels/$(notdir $*);\
	$c resource add ${col} $< labels/$(notdir $*);\
	$c relation add-container -T media ${col} labels/$(notdir $*)/media;\
	$c resource add --type MediaObject ${col} $*/label.jpg labels/$(notdir $*)/media/$(notdir $*);\
	rm -f $*/index_terms.txt; \
	if [[ -e $*/google-vision.json ]]; then \
	  $c resource add --type MediaObject -H Content-Type:application/google-vision+json ${col} $*/google-vision.json labels/$(notdir $*)/media/google-vision; \
		jq -r '.text[].desc' < $*/google-vision.json >> $*/index_terms.txt; \
	fi; \
	if [[ -e $*/label_this.json ]]; then \
	  $c resource add --type MediaObject -H Content-Type:application/google-vision+json ${col} $*/label_this.json labels/$(notdir $*)/media/label_this; \
		jq '.text[].desc' < $*/label_this.json | grep -v '^null$$' >> $*/index_terms.txt; \
	fi;\
	if [[ -e $*/index_terms.txt ]]; then \
	  $c resource add --type MediaObject ${col} $*/index_terms.txt labels/$(notdir $*)/media/index_terms; \
	  $(call indexable,${col},labels/$(notdir $*)/media/index_terms);\
	fi;
	fin http get -P b /collection/${col}/labels/$(notdir $*) > $@
