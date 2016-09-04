#!/usr/bin/env bash
# Lexicon - another special case for table
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

function POGDef::lex {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::table "$objname"
  pogInjectMethods "$classname" "$objname"
}

# ========== Write data ========== #

function POGDef::lex::getOutputFilter {
  printf '%s' "LC_ALL=C sort -b -k1,1 -k2,2nr | gawk '{pron=\"\"; for(i=3;i<=NF;i++){pron = pron \" \" \$i}} !a[\$1 \" \" pron]++ && \$2>0'"
}