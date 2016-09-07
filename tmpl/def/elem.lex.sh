#!/usr/bin/env bash
# Definition of the base lex object
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

source !.def/elem.table.sh

newClass POGElem::lex POGElem::table

function POGElem::lex::init {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  # Sort probabilities and delete zero-probability prons
  printf -v "objVar[${this}.outFilter]" '%s' "LC_ALL=C sort -b -k1,1 -k2,2nr | gawk '{pron=\"\"; for(i=3;i<=NF;i++){pron = pron \" \" \$i}} !a[\$1 \" \" pron]++ && \$2>0'"

  printf -v "objVar[${this}.get]" "${objVar[${this}.get]//' table;/' lex;}"
}
