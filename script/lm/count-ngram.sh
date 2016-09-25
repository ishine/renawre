#!/usr/bin/env bash
# Count n-gram from text
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

line_limit=900000
min_count=1
order=3

in= !!text:i
out= !!table:o:c

!@beginscript

export PATH="$PATH:$HOME/irstlm/src:$HOME/irstlm/scripts"

# Compute nlines and do split, need a LOT of space on large corpus
echo ' - Dumping and splitting...'
in::get \
  | awk 'NF>=2' \
  | cut -d' ' -f2- > $tmpdir/textall

nutt=$(cat $tmpdir/textall | wc -l)
nsplit=$(perl -e "use POSIX; print ceil($nutt*1.0/($line_limit*1.0/$nj));")
if [[ $nsplit -lt $nj ]]; then
  nsplit=$nj
fi

splitData $nsplit "$tmpdir/text" < $tmpdir/textall

# Preparing patched dictionary splitting script
install "$(which split-dict.pl)" $tmpdir/
patch -d $tmpdir -Nlp1 << "EOF"
--- aaa/split-dict.pl   2015-05-03 13:06:58.686553600 +0800
+++ bbb/split-dict.pl        2015-06-11 21:55:11.306153100 +0800
@@ -129,8 +129,7 @@
 my $oldsfx=-1;
 for (my $i=0;$i<=$#D;$i++){
        $w=$D[$i];
-       $sfx="0000$S{$w}";
-       $sfx=~s/.+(\d{3})/$1/;
+        $sfx=$S{$w}+1;
        if ($sfx != $oldsfx){
 #print STDERR "opening $output$sfx\n";
                close (OUT) if $oldsfx!= -1;
EOF


echo " - Estimating ${order}-gram..."
rm -f $tmpdir/ok.count.*
cmd_count="estimate-ngram -verbose 2 -order $order -s ML
      -text $tmpdir/text.JOB -wc $tmpdir/count.JOB.gz ;
      touch $tmpdir/ok.count.JOB"

watchProgress $nsplit <<EOF
ls $tmpdir/ok.count.* | wc -l
EOF
runjobs -tc $nj JOB=1:$nsplit $out/logs/ngram.JOB.log <<EOF
estimate-ngram -verbose 2 -order $order -s ML \
  -text $tmpdir/text.JOB -wc $tmpdir/count.JOB.gz ;
touch $tmpdir/ok.count.JOB
EOF
rm -f $tmpdir/ok.count.*

echo " - Fiding splitting statistics..."

rm -f $tmpdir/text.*
dict -InputFile=$tmpdir/textall -OutputFile=$tmpdir/dict-all -Freq=yes -sort=yes
$tmpdir/split-dict.pl --input $tmpdir/dict-all --output $tmpdir/dict. --parts=$nsplit 2> /dev/null

gawk 'FNR!=1 {gsub(".*dict\\.", "", FILENAME); print $1, FILENAME}' \
  $tmpdir/dict.* \
  | sort > $tmpdir/dict-mapping

echo " - Marginalizing n-grams..."

rm -f $tmpdir/ok.marginal.*
onestep=40
nsecs=$(perl -e "use POSIX; print ceil($nsplit/$onestep);")
# Prevent awk opening too many files
for i in $(seq 1 $onestep $nsplit); do # Marginalize each split on each section
  awk_filterdict='NR==FNR && ($2>=m1 && $2<m2) {map[$1]=$2; next}
    $1 in map || ($1=="<s>" && $2 in map) {
      if($1 in map){fname = sprintf(fpattern, NF-1) map[$1]} else{fname = sprintf(fpattern, NF-1) map[$2]};
      print $0 > fname}'
  cmd_marginal="gunzip -c $tmpdir/count.JOB.gz
    | gawk -v fpattern=$tmpdir/cpart%dg.JOB. -v m1=$i -v m2=$[$i+$onestep]
      '$awk_filterdict' $tmpdir/dict-mapping - ;
    touch $tmpdir/ok.marginal${i}g.JOB"
  watchProgress $nsplit <<EOF
ls $tmpdir/ok.marginal${i}g.* | wc -l
EOF
  runjobs -tc $nj JOB=1:$nsplit $out/logs/marginal.${i}.JOB.log <<< "$cmd_marginal"
  rm -f $tmpdir/ok.marginal${i}g.*
done

echo " - Mixing marginalized counts..."

rm -f $tmpdir/ok.marginal.*
#awk_mergecount='{cnt[$1]+=$2} END {for(i in cnt){print i,cnt[i]}}'
awk_mergecount='prev != $1 {if (length(prev)>0) print prev, cnt; cnt=0; prev=$1} 1{cnt+=$2} END {print prev, cnt}'
awk_mincount='!/<\/s>/ && $NF>=mincount {$NF -= mincount-1; print $0}'

for (( i = $order; i > 0; i-- )); do
  watchProgress $nsplit <<EOF
ls $tmpdir/ok.marginal${i}g.* | wc -l
EOF
  runjobs -tc $nj JOB=1:$nsplit $out/logs/mixmargin.JOB.log <<EOF
LC_ALL=C sort -m $tmpdir/cpart${i}g.*.JOB \
  | awk -F'\t' '$awk_mergecount' \
  | gawk -v mincount=$min_count '$awk_mincount' \
  > $tmpdir/cpart${i}g.JOB ;
rm -f $tmpdir/cpart${i}g.*.JOB ;
touch $tmpdir/ok.marginal${i}g.JOB
EOF
  rm -f $tmpdir/ok.marginal${i}g.*
done

echo " - Merging n-grams..."

# Getting the special token: <s>
gunzip -c $tmpdir/count.*.gz \
  | awk 'NF==2 && $1=="<s>" {cnt+=$2} END {print "<s>",cnt}' > $tmpdir/merged_count
for (( o = 1; o <= $order; o++ )); do
  for (( n = 1; n <= $nsplit; n++ )); do
    cat $tmpdir/cpart${o}g.${n}
  done >> $tmpdir/merged_count
done

echo " - Finalizing and generating features"
estimate-ngram -verbose 2 -c $tmpdir/merged_count \
  -o $order -wc $out/t.gz
