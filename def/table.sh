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

# ========== Base object and flow function ========== #

function POGDef::table {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::data "$objname"
  pogInjectMethods "$classname" "$objname"
}

function POGDef::table::preCheck {
  local this="$1"
  local dir="${!this}"
  if [[ -x "${dir}/get.sh" ]]; then
    return 0;
  fi
  if [[ -f "${dir}/table.gz" ]]; then
    return 0
  fi
  printError "input table $dir doesn't seem to exist"
  return 1;
}

function POGDef::table::saveMetadata {
  local this="${1}"
  $this::get | grep -v '^ ' | wc -l > "${!this}/_meta_nlines"
  return 0
}

function POGDef::table::cleanUp {
  local this="${!1}"
  rm -f "${this}/get.sh" "${this}/table.gz"
  return 0
}

# ========== Write data ========== #

function POGDef::table::sink {
  local this="${1}"
  local dir="${!this}"
  local idGetter="${2:-get}"
  $this::outputFilter \
    | gzip -nc9 > "${dir}/table.gz"
}

function POGDef::table::outputFilter {
  sed -r 's/ +$//; s/\s+/ /g;'
}

# ========== Getter ========== #

function POGDef::table::getGetter {
  local this="$1"
  local dir="${!this}"
  local idGetter="${2:-get}"
  local basePath="${3:-$dir}"

  if [[ -x "${dir}/${idGetter}.sh" ]]; then
    printf '%s' "bash '${basePath}/${idGetter}.sh'"
    return $?
  fi
  if [[ -f "${dir}/table.gz" ]]; then
    printf '%s' "gunzip -c '${basePath}/table.gz'"
    return $?
  fi

  printError "Failed to get getter from $dir"
  return 1;
}

# ========== Type-specific ========== #

function POGDef::table::getNLine {
  local this="$1"
  local dir="${!this}"
  if [[ -f "$dir/_meta_nlines" ]]; then
    cat "$dir/_meta_nlines"
  else
    $this::get | grep -v '^ ' | wc -l
  fi
  return 0
}

function POGDef::table::transpose {
  local this="$1"
  $this::get \
    | awk '{for(i=2; i<=NF; i++) lst[$i]=lst[$i] " " $1} END {for (k in lst) print k lst[k]}'
}
