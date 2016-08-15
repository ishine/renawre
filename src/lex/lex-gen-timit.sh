#!/usr/bin/env bash
# Prepare TIMIT English pronounciation dictionary
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

out= !!lex:o:c

pog-begin-script

URL='https://catalog.ldc.upenn.edu/docs/LDC93S1/TIMITDIC.TXT'
CACHEFILE="${POG_CACHEDIR}/share/timitdic.txt"
mkdir -p "$(dirname "${CACHEFILE}")"
if [[ ! -f "${CACHEFILE}" ]]; then
  wget -nv -O "${CACHEFILE}" "$URL"
fi # end if there's no cached file

grep -v '^;' "$CACHEFILE" \
  | perl -lpe 's#/##g; s/[0-9]//g' \
  | gawk '!/^[^a-z]/ && !($1 ~ /[^a-z]$/) {$1 = $1 " 1.0000"; print $0}' \
  | out::sink
