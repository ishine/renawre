#!/usr/bin/env bash
# Definition of a phone set
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

source !.def/data.sh
source !.def/elem.table.sh

newClass POGDef::pset POGDef::data

# Phoneset table format:
#
# phn [tag1 tag2 ...]
#  share phn1 phn2 phn3 ... # comment line for base-sharing phone
#  question phn1 phn2 phn3 ... # comment line for clustering rule
#
# Essential tags:
# nonsil sil

function POGDef::pset::init {
  local this="$1"
  $this::addElem table t
  printf -v "objVar[${this}.defaultElem]" t
}

# phone set should not have duplicated keys
function POGDef::pset::postCheck {
  local this="$1"
  POGDef::data::postCheck "$this"

  if ! $this::get | awk '/^ / {next} $1 in a {print "duplicated key: " $1; exit 1} 1 {a[$1]=1}'; then
    printError "Problems detected, there maybe something wrong in main script"
    return 1
  fi
  return 0
}
