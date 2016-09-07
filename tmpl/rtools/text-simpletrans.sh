#!/usr/bin/env bash
# Script to apply some simple transforms to text
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

set -euo pipefail

# Break continuous CJK characters into separate characters
function trans:breakCJKChars {
  perl -CSAD -lane '$F[$_] =~ s/(\p{Block=CJK_Unified_Ideographs})/ \1 /g for (1..$#F);
$rslt = join(" ", @F);
$rslt =~ s/ +/ /g; $rslt =~ s/ +$//;
print $rslt'
}

# Combine CJK characters into continuous chunk
function trans:unbreakCJKChars {
  perl -CSAD -lpe 's/(\p{Block=CJK_Unified_Ideographs}) (?=\p{Block=CJK_Unified_Ideographs})/\1/g'
}

# Strip special tags
function trans:stripTags {
  sed -r 's/ \{[^}]+}//g; s/ <[^>]+>//g'
}

# Strip all symbols and punctuations
function trans:stripPunctuations {
  perl -CSAD -lane '$F[$_] =~ s/\p{P}|\p{C}|\p{S}|\p{M}//g for (1..$#F);
$rslt = join(" ", @F);
$rslt =~ s/ +/ /g; $rslt =~ s/ +$//;
print $rslt'
}

# Convert all english into lowercase
function trans:toLower {
  awk '{for(i=2; i<=NF; i++) $i=tolower($i)}1'
}

# Convert all english into uppercase
function trans:toUpper {
  awk '{for(i=2; i<=NF; i++) $i=toupper($i)}1'
}

# Number (123) into Chinese number (一二三)
function trans:numberToChinese {
  perl -CSAD -lane 'use utf8; $F[$_] =~ tr/0123456789/零一二三四五六七八九/ for (1..$#F);
print join(" ", @F)'
} #

if [[ "$#" -lt 1 || "$1" == -h || "$1" == --help ]]; then
  echo ' + Available transforms:' >&2
  compgen -A function trans: | sed 's/^trans://'
  exit 1
fi

cmd="$(printf '%s\n' "${*}" | sed -r 's/ / | /g; s/[A-Za-z0-9_]+/trans:&/g')"
eval "$cmd"
