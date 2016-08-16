#!/usr/bin/env bash
# Build all scripts under this dir
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

set -euo pipefail

while [[ -n "${1:-}" ]]; do
  node_modules/.bin/browserify -t [ babelify --presets [ es2015 ] ] -g uglifyify \
    --node rtools/src-js/${1} > rtools/${1}
  shift
done
