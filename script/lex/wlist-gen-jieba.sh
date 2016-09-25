#!/usr/bin/env bash
# Prepare Jieba word-list
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

raw=0 # Whether to keep all words in jieba word list

out= !!table:o:c

!@beginscript

URL='https://github.com/yanyiwu/cppjieba/blob/master/dict/jieba.dict.utf8?raw=true'
CACHEFILE="${POG_CACHEDIR}/share/jiebalist"
mkdir -p "$(dirname "${CACHEFILE}")"
if [[ ! -f "${CACHEFILE}" ]]; then
  wget -nv -O "${CACHEFILE}" "$URL"
fi # end if there's no cached file

cat "$CACHEFILE" \
  | opencc -c s2tw.json > $tmpdir/jieba_raw

if [[ $raw == 1 ]]; then
  cat $tmpdir/jieba_raw | out::sink
else
  # Filter out weird words or words containing too many numbers
  awk '!/..人 |^[再可喔在多了上沒點]{2,} |([零點一二三四五六七八九十百千萬歲斤尺丈品個位第兩][^ ]*){2,}/ && length($1) <= 4' $tmpdir/jieba_raw > $tmpdir/jieba_filtered
  # De-duplicate the word list for chinese segmentation usage
  # aka. if a >3-word phrase include another <3-word phrase, delete the longer one
  # Finally, only keep those with frequency 5 or higher
  awk 'length($1) == 1 || $1 ~ /[A-Za-z0-9]/ {next}
    NR==FNR && (length($1) == 2 || length($1) == 3) {
      inc[$1]=1;
      next
    }
    NR!=FNR && length($1) == 2 {
      print $0;
      next
    }
    NR!=FNR {
      keep=1;
      for(i=1; i<=length($1)-1; i++)
        if (substr($1, i, 2) in inc || substr($1, i, 3) in inc)
          keep=0;
      if(keep==1)
        print $0
    }' $tmpdir/jieba_filtered $tmpdir/jieba_filtered \
    | awk '$2>=5' \
    | out::sink
fi # end if $raw == 1
