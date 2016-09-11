#!/usr/bin/env bash
# Compute precision-recall from the definitions written in table
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

ref= !!table:i
hyp= !!table:i
out= !!errorPR:o:c

!@beginscript

# For some unknown reason, this program doesn't allow /dev/fd/n for input file...
awk -f !.rtools/pr-from-table.awk <(ref::get) <(hyp::get) \
  | out%details::sink
perl !.rtools/pr-stats-by-kw.pl < <(out%details::get) \
  | out%kws::sink
perl !.rtools/pr-stats-by-utt.pl < <(out%details::get) \
  | out::sink
