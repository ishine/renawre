#!/usr/bin/env bash
# Prepare CEDict Mandarin pronounciation dictionary
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

URL='https://www.mdbg.net/chindict/export/cedict/cedict_1_0_ts_utf-8_mdbg.txt.gz'
CACHEFILE="${POG_CACHEDIR}/share/cedict"
mkdir -p "$(dirname "${CACHEFILE}")"
if [[ ! -f "${CACHEFILE}" ]]; then
  wget -nv -O "${CACHEFILE}" "$URL"
fi # end if there's no cached file

# awk delete comments and non-mandarin words and punctuations (cleanup)
# perl formatting, getting only first col (zh-tw), and third col (pron)
# awk delete duplicate and delete too-long words
gunzip -c "$CACHEFILE" \
  | awk '!/^\s*#/ && !($1 ~ /[a-zA-Z0-9]/) && !($1 ~ /[、。，·,・.%�]/) && !/xx5/' \
  | perl -CSAD -lpe 's/^([^ ]+) [^ ]+ \[([^\]]*)\] .*/\1 1.0000 \L\2/' \
  | gawk '!a[$0]++ && length($1) <= 5' \
  | out::sink
