#!/usr/bin/env bash
# Prepare CMU English pronounciation dictionary
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

URL='http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b'
CACHEFILE="${POG_CACHEDIR}/share/cmudict"
mkdir -p "$(dirname "${CACHEFILE}")"
if [[ ! -f "${CACHEFILE}" ]]; then
  wget -nv -O "${CACHEFILE}" "$URL"
fi # end if there's no cached file

# perl normalize words like APPLE(2)
# then delete some wrongful characters (this is an English lexicon!)
# awk casts all english words into lower case
grep -v '^;;;' "$CACHEFILE" \
  | perl -lpe 's/^([^ ]+)\([0-9]+\) /$1 /; s/[^[:ascii:]]//g; s/  / 1.0 /' \
  | awk '{$1 = tolower($1)}1' \
  | out::sink
