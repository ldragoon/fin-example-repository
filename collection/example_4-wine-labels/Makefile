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
	if [[ -e $*/google-vision.json ]]; then \
	  fin http put -@ $*/google-vision.json -H Content-Type:application/google-vision+json /collection/${col}/labels/$(notdir $*)/media/google-vision; \
	  $(call indexable,${col},labels/$(notdir $*)/media/google-vision);\
		eval "echo -e $(jq '.text[0].desc' < $*/google-vision.json )" > $*/google-vision.txt; \
	  $c resource add --type MediaObject ${col} $*/google-vision.txt labels/$(notdir $*)/media/google-vision_text; \
	  $(call indexable,${col},labels/$(notdir $*)/media/google-vision_text);\
	fi; \
	if [[ -e $*/label_this.json ]]; then \
	  $c resource add --type MediaObject ${col} $*/label_this.json labels/$(notdir $*)/media/label_this; \
	  $(call indexable,${col},labels/$(notdir $*)/media/label_this);\
		eval "echo -e $(jq '.text[0].desc' < $*/label_this.json )" > $*/label_this.txt; \
	  $c resource add --type MediaObject ${col} $*/label_this.txt labels/$(notdir $*)/media/label_this_text; \
	  $(call indexable,${col},labels/$(notdir $*)/media/label_this_text);\
	fi;
	fin http get -P b /collection/${col}/labels/$(notdir $*) > $@
