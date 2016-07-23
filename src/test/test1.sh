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

pog-begin-script

xxx=yy !!data:i
xxx2=1556
xxx3=()

input='' !!data:i:r # This is one
output=() !!data:o:r

!!source pogbase/parseopts.sh

sleep 2
echo 1556
echo 1778
