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

source !.def/data.sh
source !.def/elem.table.sh

newClass POGDef::text POGDef::data

function POGDef::text::init {
  local this="$1"
  $this::addElem table t
  printf -v "objVar[${this}.defaultElem]" t
}
