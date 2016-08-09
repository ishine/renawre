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

source !.def/table.sh

# ========== Base object and flow function ========== #

function POGDef::errorPR {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::table "$objname"
  pogInjectMethods "$classname" "$objname"
}

function POGDef::errorPR::preCheck {
  local this="$1"
  local dir="${!this}"
  if [[ ! -x "${dir}/pretty.sh" ]]; then
    printError "input $dir/pretty.sh doesn't seem to exist"
    return 1;
  fi
  if [[ ! -f "${dir}/table.gz" ]]; then
    printError "input $dir/table.gz doesn't seem to exist"
    return 1
  fi
  return 0;
}

# Should write proper pretty.sh
function POGDef::text::postCheck {
  local this="$1"
  local dir="${!this}"
  if [[ ! -x "${dir}/pretty.sh" ]]; then
    printError "output $dir/pretty.sh doesn't seem to exist"
    return 1;
  fi
  return 0
}

# ========== Type-specific ========== #

# Write a shell script to pretty-print error data
function POGDef::errorPR::writePrettyPrinter {
  local this="$1"
  $this::initializeGetter pretty
  (
    $this::getGetter '' .;
    printf " | tail -n 1 | awk '{printf(\"%s %s  %s\\\\n\", \$2, \$3, \$8, \$9, \$10)}'" \
      '\033[1;35m + Results:' \
      '\033[;33mP=\033[1m%s \033[;33mR=\033[1m%s' \
      '\033[;37mF0.5=\033[1m%s  \033[;33mF1=\033[1m%s  \033[;37mF2=\033[1m%s\033[m'
  ) | $this::writeToGetter pretty
} # end function POGDef::errorPR::writePrettyPrinter
