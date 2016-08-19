#!/usr/bin/env bash
# Find OOV words
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

in= !!text:i
lex= !!table:i
out= !!table:o:c

pog-begin-script

in::get \
  | gawk \
  'NR==FNR {ok[$1];next} 1{for(i=2; i<=NF; i++) if(!($i in ok)) print $i}' \
  <(lex::get) - \
  | LC_ALL=C sort \
  | LC_ALL=C uniq -c \
  | awk '{print $2,$1}' \
  | out::sink

printf "\e[;1m + Got %d OOVs, in total appear %d times.\e[m\n" \
  $(out::get | wc -l) \
  $(out::get | gawk '{sum+=$2} END {print sum}')
