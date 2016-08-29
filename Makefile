SHELL := /usr/bin/env bash
#UNITS := rtools/azo.sh rtools/new.sh
UNITS := rtools/new.sh

include ../common.mk
ifdef POGB_POGSOURCE

all: $(UNITS:%=dest/%)

include $(UNITS:%=_buildcache/%.mk)

_buildcache/%.cache: % _buildcache $(POGB_POGSOURCE)/compiler/pog_parse.sh
	$(eval basetarget := $(@:_buildcache/%.cache=%))
	$(eval basedir := $(<:%/$(basetarget)=%))
	pog_parse.sh $(basedir) $(basetarget) $@

_buildcache/%.mk: _buildcache/%.cache $(POGB_POGSOURCE)/compiler/pog_mkdepend.sh
	$(eval basetarget := $(@:_buildcache/%.mk=%))
	pog_mkdepend.sh $(basetarget) dest _buildcache "$@" $^

_buildcache:
	@unlink _buildcache || true
	ln -s "$$(mktemp -d "/tmp/pog.tmp.XXXXXXXXXX")" _buildcache

dest/%: _buildcache/%.cache
	@mkdir -p $(dir $@)
	@touch $@
	@echo $@ $< $*

endif
