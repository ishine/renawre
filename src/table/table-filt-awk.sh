#!/usr/bin/env bash
# Use awk command from stdin to filter a table
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

file= # Use input file instead of stdin

in= !!table:i
out= !!table:o:c

realize=0

!@beginscript

out::initializeGetter
in::getRelGetter "" out | out::writeToGetter
printf " | awk '%s'" "$(sed "s/'/'\\\\''/g" ${file:--})" | out::writeToGetter

if [[ $realize == 1 ]]; then
  out::realize
fi # end if $realize == 1
