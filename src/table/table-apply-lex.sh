#!/usr/bin/env bash
# Apply a lexicon to another table
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

strict=1 # Strict mode: fail if something isn't in mapping
filler=" " # Filler between multiple mapped units

in= !!table:i
map= !!lex:i
out= !!table:o:c

realize=0

!@beginscript

out::initGetter
{
  !#rtools/table-apply.awk
  map::getRelGetter "$out"
  printf ' | awk -v startcol1=3 -v filler="%s" -v strict=%d -f <(~GET!%s)' \
    "$filler" $strict "rtools/table-apply.awk"
  printf ' /dev/stdin <('
  in::getRelGetter "$out"
  printf ')'
} | out::writeGetter

if [[ $realize == 1 ]]; then
  out::realize
fi # end if $realize == 1
