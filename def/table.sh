#!/usr/bin/env bash
# Definition of the base table object
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

function POGDef::table {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::data "$objname"
  pogInjectMethods "$classname" "$objname"
}

function POGDef::table::preCheck {
  local this="${!1}"
  if [[ -x "${this}/get.sh" ]]; then
    return 0;
  fi
  if [[ -f "${this}/table.gz" ]]; then
    return 0
  fi
  printError "input table $this doesn't seem to exist"
  return 1;
}

function POGDef::table::get {
  local this="${!1}"
  if [[ -x "${this}/get.sh" ]]; then
    bash "${this}/get.sh"
    return $?
  fi
  if [[ -f "${this}/table.gz" ]]; then
    gunzip -c "${this}/table.gz"
    return $?
  fi
  printError "Failed to get from $this"
  return 1;
}

function POGDef::table::sink {
  local this="${!1}"
  cat \
    | sed -r 's/^ +//; s/ +$//; s/\s+/ /g;'
    | gzip -nc9 > "${this}/table.gz"
}

function POGDef::table::cleanUp {
  local this="${!1}"
  rm -f "${this}/get.sh" "${this}/table.gz"
  return 0
}
