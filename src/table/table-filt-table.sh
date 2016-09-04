#!/usr/bin/env bash
# Filter a table by the key of another table
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

inverse=0 # Filter out instead of filter in

in= !!table:i
key= !!table:i
out= !!table:o:c

realize=0

!@beginscript

out%t::initGetter
in::getRelGetter "" out | out%t::writeGetter

printf '| awk -v inv="%d" '\''%s %s'\'' <(%s) /dev/stdin' $inverse \
  'NR==FNR{if (!/^ /) d[$1]=1; next}' \
  '(inv==0 && $1 in d) || (inv==1 && !($1 in d))' \
  "$(key::getRelGetter "" out)" | out%t::writeGetter

if [[ $realize == 1 ]]; then
  out::realize
fi # end if $realize == 1
