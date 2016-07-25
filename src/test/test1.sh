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

xxx= !!data:i:h:opt
xxx2=1556
xxx3=()

in= !!data:i # This is one
out= !!data:o

pog-begin-script

echo FD1
echo FD2 >&2
echo FD5 >&5
echo FD6 >&6
