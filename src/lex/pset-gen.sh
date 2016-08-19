#!/usr/bin/env bash
# Generate a phoneset, builtin or from a file
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

file= # Use input file instead of stdin

addtag=()
addtable=() !!table:i:opt # Table containing a list of add-tag phones

out= !!pset:o:c

pog-begin-script

(
  for ((i=0; i<${#addtable[@]}; i++)); do
    addtable[$i]::get \
      | awk "{print \$1, \"${addtag[$i]}\"}"
  done; unset i
  cat "${file:--}" \
    | awk 'NF==1 {print $1, "nonsil"; next} 1'
) | out::sink
