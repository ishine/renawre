#!/usr/bin/env bash
# Apply a table to a lexicon
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

strict=0 # Strict mode: fail if something isn't in mapping
pset= !!pset:opt:i # Check against a phoneset, will disable strict mode if specified

in= !!lex:i
map= !!table:i
out= !!lex:o:c

realize=0

!@beginscript

# In case we're already going to check againset phone set, disable strict mode
if [[ -n "${pset:-}" ]]; then
  strict=0
fi # end if phoneset specified

out::initGetter
{
  !#rtools/table-apply.awk
  map::getRelGetter "$out"
  printf ' | awk -v startcol2=3 -v strict=%d -f <(~GET!%s)' \
    $strict "rtools/table-apply.awk"
  printf ' /dev/stdin <('
  in::getRelGetter "$out"
  printf ')'
} | out::writeGetter

if [[ $realize == 1 ]]; then
  out::realize
fi # end if $realize == 1

# Check correctness if phoneset if specified
if [[ -n "${pset:-}" ]]; then
  out::checkInSet pset 3 # FIXME
fi
