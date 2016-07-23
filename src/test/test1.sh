#!/usr/bin/env bash
# The testing script
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


xxx=yy !!data:i
xxx2=1556
xxx3=()

in= !!data:i:r:v # This is one
in2=() !!data:i:r:v # This is two
out= !!data:o:r:v

!!source pogbase/parseopts.sh
pog-begin-script

thresholdPath "aaa/ccc/ddd/eee/fff/ggg" 13
echo
thresholdPath "zzz/aaacccdddeeefffggg" 13
echo

sleep 2
echo 1556
echo 1778
