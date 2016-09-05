#!/usr/bin/env bash
# Definition of the PR-info prettifier
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

newClass POGElem::prettyPR POGElem::data

function POGElem::prettyPR::init {
  local this="$1"

  if [[ -z "${objVar[${this}.target]-}" ]]; then
    printError "Need variable ${this}.target] set to prettify target"
    exit 16
  fi
  return 0
}

function POGElem::prettyPR::cleanUp {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  rm -f "${dir}/${nameElem}.sh"
  return 0
}

# Should write proper pretty.sh
function POGElem::prettyPR::postCheck {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"

  if [[ ! -x "$dir/${nameElem}.sh" ]]; then
    printError "output $dir/${nameElem}.sh doesn't seem to exist"
    return 1;
  fi
  return 0
}

# This is mandatory things to run
function POGElem::prettyPR::postProcess {
  local this="$1"
  local nameObj="${this%%\%*}"
  local nameElem="${this#*\%}"
  local dir="${!nameObj}"
  local target="${objVar[${this}.target]}"

  # Write the pretty-printer
  $this::initGetter
  {
    $target::getRelGetter "$dir";
    printf " | tail -n 1 | awk '{printf(\"%s %s  %s\\\\n\", \$2, \$3, \$8, \$9, \$10)}'" \
      '\033[1;35m + Results:' \
      '\033[mP=\033[1m%s \033[mR=\033[1m%s' \
      '\033[mF0.5=%s  F1=\033[1m%s  \033[mF2=%s'
  } | $this::writeGetter

  ${dir}/${thisElem}.sh

  return 0
}
