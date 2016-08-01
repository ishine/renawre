#!/usr/bin/env bash
# Text - a special kind of table
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

source !.def/table.sh

# ========== Base object and flow function ========== #

function POGDef::text {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::table "$objname"
  pogInjectMethods "$classname" "$objname"
}

# ========== Type-specific ========== #

# apply all transformations in order
function POGDef::text::chainTrans {
  local this="$1"
  local cmdFull="cat"
  while [[ -n "${2:-}" ]]; do
    cmdFull+=" | $this::trans_$2"
    shift
  done
  eval "$cmdFull"
} # end function doAllTrans

# Break continuous CJK characters into separate characters
function POGDef::text::trans_breakCJKChars {
  perl -CSAD -lpe 's/(\p{Block=CJK_Unified_Ideographs})/ \1 /g; s/ +/ /g; s/ $//'
} # end function POGDef::text::breakCJKChars

# Strip special tags
function POGDef::text::trans_stripTags {
  sed -r 's/ \{[^}]+}//g; s/ <unk>//g'
} # end function POGDef::text::stripTags
