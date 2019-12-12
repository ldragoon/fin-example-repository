#! /usr/bin/make -f
SHELL:=/bin/bash

col:=chardonnay

all: ${col}/graph.hdt

${col}/graph.hdt: graph.ttl
	rdf2hdt $< $@
