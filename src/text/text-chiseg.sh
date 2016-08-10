#!/usr/bin/env bash
# CJK segmentation based on dictionary
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

source !.req/jieba.sh

wlist= !!table:i
in= !!text:i
out= !!text:o:c

pog-begin-script

# Make proper word list including word frequency
wlist::get \
  | awk '{print $1 " " length($1)**2*10}' > $tmpdir/wlist

python3 !.rtools/chiseg_jieba.py --skip 1 $tmpdir/wlist <(in::get) \
  | out::sink
