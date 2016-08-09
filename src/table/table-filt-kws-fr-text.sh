#!/usr/bin/env bash
# Extract a list of keywords from a text
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
kws= !!table:i
out= !!table:o

pog-begin-script

# Get filter based on keywords
filter="$(kws::get \
| perl -lpe "s/^[A-Za-z0-9_'-]+\$/\\\\<\$&\\\\>/; #Match whole english word" \
| tr '\n' '|' \
| sed 's/|$//; s/|/\\|/g')"

in::get \
  | grep -v '^ ' \
  | grep -on "${filter}" \
  | gawk 'NR==FNR {a[$1] = a[$1] " " $2; next} 1{print $1 a[FNR]}' FS=":" - FS=" " <(in::get) \
  | out::sink
