#!/usr/bin/env bash
# Text from Chinese Gigaword corpora
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

corpora= !!a:h
setname= !!a # afp, cna, cns, gmw, pda, pla, xin, zbn
out= !!text:o:c

!@beginscript

# Find out the actual path of target and check it
CROOT="$(readlink -f "$corpora/data/${setname}_cmn")"
if [[ ! -d "$CROOT" ]]; then
  printErr "Error: $CROOT doesn't seem to exist, is setname wrong?"
  exit 1
fi

if [[ $setname == cna ]]; then
  cmd_opencc=
else
  cmd_opencc='| opencc -c s2tw.json'
fi

# Prepare file list
ls $CROOT/*.gz > "$tmpdir/flist_all"
cat "$tmpdir/flist_all" | splitData $nj "$tmpdir/flist"

echo " - Extracting text..."
watchProgress $(cat "$tmpdir/flist_all" | wc -l) <<EOF
cat $out/logs/cgw.{1..$nj}.log | grep '\.gz:.*%\$' | wc -l
EOF
# While loop: restart node to prevent mem explode
runjobs JOB=1:$nj $out/logs/cgw.JOB.log <<EOF
while IFS=\$'\n' read -r fname; do
  gunzip -vc \$fname \
  | node !.rtools/corpus-cgw-story.js ;
done < $tmpdir/flist.JOB \
  ${cmd_opencc} \
  | $(out::getSink $tmpdir/text.out.JOB.gz)
EOF

echo " - Combining..."
mergeData $nj "$tmpdir/text.out.%d.gz" 0 > $out/t.gz
