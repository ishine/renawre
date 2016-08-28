
DIRWITHENV := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
ifndef POGB_POGSOURCE
all: .DEFAULT
.DEFAULT:
ifndef POGB_STOPLAYER
	set -e; export POGB_STOPLAYER=1; source "$(DIRWITHENV)/env.sh"; $(MAKE) --no-print-directory $(MAKEFLAGS) $(MAKECMDGOALS)
endif
else
  VPATH = $(POGB_ROOTLIST):.
endif
