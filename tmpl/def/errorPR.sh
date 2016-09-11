#!/usr/bin/env bash
# Definition of Precision-recall error table
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
source !.def/elem.prettyPR.sh
source !.def/data.sh

newClass POGDef::errorPR POGDef::data

function POGDef::errorPR::init {
  local this="$1"
  printf -v "objVar[${this}.defaultElem]" t
  printf -v "objVar[${this}%pretty.target]" '%s' "${this}%t"

  $this::addElem table t
  $this::addElem table details
  $this::addElem table kws
  $this::addElem prettyPR pretty
}
