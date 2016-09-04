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

source !.def/elem.data.sh

newClass POGElem::table POGElem::data

function POGElem::table::init {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  printf -v "objVar[${this}.outFilter]" '%s' "sed -r 's/ +\$//; s/\s+/ /g;'"
  printf -v "objVar[${this}.sink]" "gzip -nc9 > '${dir}/${nameElem}.gz'"
  printf -v "objVar[${this}.get]" "if [[ -x '%s' ]]; then bash '%s' --nofilter; else gunzip -c '%s'; fi" \
    "${dir}/${nameElem}.sh" "${dir}/${nameElem}.sh" \
    "${dir}/${nameElem}.gz"
}

# ========== Flow function ========== #

function POGElem::table::preCheck {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  if [[ -x "${dir}/${nameElem}.sh" ]]; then
    return 0;
  fi
  if [[ -f "${dir}/${nameElem}.gz" ]]; then
    return 0
  fi
  printError "input element ${this} doesn't seem to exist"
  return 1;
}

function POGElem::table::cleanUp {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  rm -f "${dir}/${nameElem}".{sh,gz}
  return 0
}
