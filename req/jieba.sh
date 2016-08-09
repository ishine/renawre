#!/usr/bin/env bash
# python-jieba
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

source !.req/python3.sh

function _checker {
  if ! python3 -c 'import jieba'; then
    printError 'Jieba module in python3 is not available, this script need it to work'
    printError 'You may want to use: pip install jieba3k'
    exit 27
  fi
}
_checker
unset _checker