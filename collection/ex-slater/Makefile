#! /usr/bin/make -f
SHELL:=/bin/bash

inf4:=~/fin-example-repository/inf4
col:=$(shell eval `${inf4} util.config`; echo $${INF4[source_collection]})
item_images:=$(shell find ${col}/D-394 -name \*.jpg)

items:=$(shell find ${col}/D-394 -maxdepth 1  -type d)

INFO:
	echo items: ${items}
	@echo images: ${item_images}

define images.ttl
@prefix schema:  <http://schema.org/> .
@prefix ucdlib:  <http://digital.ucdavis.edu/schema#> .
@prefix ldp:  <http://www.w3.org/ns/ldp#> .

<> a schema:MediaObject ldp:DirectContainer ucdlib:ImageList;
    schema:name "Image List" ;
    ldp:membershipResource      <.> ;
    ldp:hasMemberRelation       schema:hasPart ;
    ldp:isMemberOfRelation      schema:partOf ;
    .
endef

text_file=$(subst images,text,$(subst .jpg,.txt,$1))

define tesseract
tesseract::$(call text_file,$1)

$(call text_file,$1):$1
	[[ -d $(dir $(call text_file,$1)) ]] || mkdir $(dir $(call text_file,$1))
	tesseract $1 $(subst .txt,,$(call text_file,$1)) -l eng --psm 1 --oem 1 txt
endef
$(foreach i,${item_images},$(eval $(call tesseract,$i)))

define ttl
ttl::$1.ttl

$1.ttl:$1
	${inf4} file.metadata -n -a --extra="schema:position $(basename $1 .jpg | cut -d- -f2);" $1 > $1.ttl
endef

$(foreach i,${item_images},$(eval $(call ttl,$i)))
