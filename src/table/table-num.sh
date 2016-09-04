#!/usr/bin/env bash
# Numbering table keys, mainly for FST use
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

no_special=0 # Don't use special symbols like rho and phi
num_disambig=0 # Number of disambig symbols after normal content

in= !!table:i
out= !!table:o:c

!@beginscript

{
  if [[ "$no_special" == 1 ]]; then
    shift
    startnum=1
    printf '%s 0\n' '<eps>'
  else
    startnum=11
    printf '%s 0\n%s 6\n%s 7\n%s 8\n%s 9\n%s 10\n' \
      '<eps>' '#0' '<phi>' '<sigma>' '<rho>' '<bound>'
  fi

  in::get \
    | awk 'NF >= 1 && !/^ / {print $1}' \
    | LC_ALL=C sort -u \
    | awk -v st=$startnum -v nd=$num_disambig \
    '{print $1 " " st++} END {for (i=1; i<=nd; i++) print "#" i " " st++}'
} | out::sink
