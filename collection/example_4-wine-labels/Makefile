#!/usr/bin/make -f
SHELL:=/bin/bash

c:=fin collection

col:=example_4-wine-labels

labels:=$(shell find folder -type d -name label_\*)
ldp:=$(patsubst %,%/ldp.ttl,${labels})


.PHONY: ldp
ldp:ldp.ttl ${ldp}

index.ttl: index.ttl.in
	node link_list.js > $@

ldp.ttl: agents:= quinn enebeker
ldp.ttl: schema:=http://www.schema.org
ldp.ttl:
	$c delete -f ${col};\
	$c create ${col} index.ttl;\
  $c acl group add ${col} admins rw $(patsubst %,--agent %@ucdavis.edu,${agents});\
  $c relation add-container ${col} labels -T part;\
  $c relation add-properties ${col} ${schema}/workExample labels/label_0374/media/0374 ${schema}/exampleOfWork
	fin http get -P b /$collection/${col} > $@


${ldp}:%/ldp.ttl:%/metadata.ttl
	$c resource delete ${col} labels/$(notdir $*);\
	$c resource add ${col} $< labels/$(notdir $*);\
	$c relation add-container -T media ${col} labels/$(notdir $*)/media;\
	$c resource add --type MediaObject ${col} $*/label.jpg labels/$(notdir $*)/media/$(notdir $*);\
	fin http get -P b /collection/${col}/labels/$(notdir $*) > $@
