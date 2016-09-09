# Makefile to include special things from renawre
#***************************************************************************
#  Copyright 2014-2016, mettatw
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#***************************************************************************

define renawre_singlerule =
$(1): $(dir $(1))rdata
endef

$(foreach file,$(UNITS),$(eval $(call renawre_singlerule,$(file))))

# Building all directory linking rule

define renawre_dirrule =
$(1)/rdata: $(1)
	@if [[ -h "$$@" ]]; then unlink "$$@"; fi
	@if [[ ! -e "$$@" ]]; then ln -s "$(RENAWRE_ROOT)/builtindata" "$$@"; fi
endef

$(foreach dir,$(DIRS),$(eval $(call renawre_dirrule,$(dir))))
