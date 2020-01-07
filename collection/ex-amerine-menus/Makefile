#!/usr/bin/make -f
SHELL:=BASH_ENV=../fin-functions.sh /bin/bash

#ifndef common.mk
#include common.mk
#endef

c:=fin collection

col:=amerine-menus
R:=/fcrepo/rest

#This captures all the arks
items:=$(wildcard items/D-060/*/*/* )
#item_images:=$(wildcard items/D-060/*/*/*/media/images/*.jpg )
item_images:=$(wildcard items/D-060/*/*/*/media/images/*.png )
schema:=http://schema.org

#ex:=items/D-060/42/172/d7dk6z
ex:=items/D-060/42/172/d71941
#ex:=items/d7dk6z

INFO:
	@echo -e "try: make new-collection add-graph ldp ldp.ttl\n\nto make this collection";
#	echo -e "\n\nVARS:\n  ex:${ex}\n  items: ${items}";
#	echo item_images: ${item_images}

define patch
  fin http patch --data-string "INSERT {<> $3 } WHERE {}" -P h /collection/$1/$2/fcr:metadata
endef

graph.hdt: graph.ttl
	rdf2hdt $< $@

col_ark:=d79c7b

query:=PREFIX schema: <http://schema.org/>\
PREFIX dark: <https://digital.ucdavis.edu/ark:/87287/>\
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>\
CONSTRUCT ?o schema:name ?l\
WHERE {\
  { GRAPH dark:${col_ark}\
   {?s ?p ?o. FILTER isURI(?o) }\
  }\
  OPTIONAL { graph ?t { ?o skos:prefLabel ?l } }\
}

graph.ttl:jena:=http://localhost:3030/dams/query
graph.ttl:
	http --form ${jena} Accept:text/turtle query='${query}' > $@

.PHONY: add-graph
add-graph: d:=http://digital.ucdavis.edu/schema
add-graph: graph.hdt
	fin rm /collection/${col}/graph
	$c resource add ${col} -H "Content-Type: application/octet-stream" $< graph
	$c relation add-properties ${col} ${d}#hasGraph graph ${d}#isGraph

add-workExample: schema:=http://schema.org
add-workExample: ex_ark:=$(lastword $(subst /, ,${ex}))
#	$c relation add-properties ${col} ${schema}/workExample ${ex} ${schema}/exampleOfWork;
#	$c relation add-properties ${col} ${schema}/image ${ex_ark}/media/images/${ex_ark}-0 ${schema}/exampleOfWork;
add-workExample:
	  $(call patch,${col},,<${schema}/image> <${ex_ark}/media/images/${ex_ark}-0> .);

agents:= quinn enebeker jrmerz
schema:=http://www.schema.org

ifdef update
ldp:: ldp.ttl

# When updating the collection data, you actually need to copy in any existing accesscontrol information
ldp.ttl: index.ttl
	fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ index.ttl -P h /collection/${col}
	fin http patch --data-string "INSERT {<> <http://www.w3.org/ns/auth/acl#accessControl> <$R/collection/${col}/.acl> . } WHERE {}" -P h /collection/${col}/fcr:metadata
	fin http get -P b /collection/${col} > $@

else

.PHONY:new-collection

new-collection: graph.hdt
	$c delete -f ${col};\
	$c create ${col} index.ttl;\
  $c acl group add ${col} admins rw $(patsubst %,--agent %@ucdavis.edu,${agents});\
  $c relation add-container ${col} items -T part;

ldp.ttl: add-workExample
	fin http get -P b /collection/${col} > $@

clean::
	rm ldp.ttl
endif

# Handy functions
item=$(notdir $1)
#item=$1

define ldp

ldp::$(patsubst %,%/ldp.ttl,$1)
clean::
	rm -f $1/ldp.ttl

ifdef update

$(patsubst %,%/ldp.ttl,$1):$1/index.ttl
	fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ $1/index.ttl -P h /collection/${col}/items/$(call item,$1)
	fin http get -P b /collection/${col}/items/$(call item,$1) > $$@

else

$(patsubst %,%/ldp.ttl,$1):$1/index.ttl
	$c resource delete ${col} items/$(call item,$1);\
	$c resource add ${col} items/$(call item,$1);\
	$c relation add-container -T media ${col} items/$(call item,$1)/media;\
	$c resource add ${col} image_list.ttl items/$(call item,$1)/media/images;\
	$c resource add ${col} text_list.ttl items/$(call item,$1)/media/text;\
  for f in $1/media/images/$(call item,$1)-*.png; do \
    b=$$$$(basename $$$$f .png);\
	  i=items/$(call item,$1)/media/images/$$$$b;\
    p=$$$${b#*-};\
    $c resource add --type MediaObject ${col} $$$$f $$$$i;\
	  patch="<http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#filename> \"$$$${b}.png\"; <http://schema.org/position> $$$$p .";\
	  $(call patch,${col},$$$$i,$$$$patch);\
		t=$1/media/text/$$$${b}.txt; \
	  tt=items/$(call item,$1)/media/text/$$$$b;\
		if [[ -s $$$$t ]]; then \
	    $c resource add --type MediaObject ${col} $$$$t $$$$tt;\
	    patch="<http://digital.ucdavis.edu/schema#textIndexable> true; <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#filename> \"$$$${b}.txt\"; <http://schema.org/encodesCreativeWork> <$R/collection/${col}/items/$(call item,$1)/media/images/$$$$b> ; <http://schema.org/position> $$$$p .";\
	    $(call patch,${col},$$$$tt,$$$$patch);\
		fi; \
  done;
	# Now add the item
	fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ $1/index.ttl -P h /collection/${col}/items/$(call item,$1);
	fin http get -P b /collection/${col}/items/$(call item,$1) > $$@
endif

endef

$(foreach i,${items},$(eval $(call ldp,$i)))

# Define tesseract to get rules for text file creation
#ifdef tesseract

text_file=$(subst images,text,$(subst .png,.txt,$1))
define tesseract
tesseract::$(call text_file,$1)

$(call text_file,$1):$1
	[[ -d $(dir $(call text_file,$1)) ]] || mkdir $(dir $(call text_file,$1))
	tesseract $1 $(subst .txt,,$(call text_file,$1)) -l eng --psm 1 --oem 1 txt
endef

$(foreach i,${item_images},$(eval $(call tesseract,$i)))

#endif
