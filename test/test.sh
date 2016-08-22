#!/usr/bin/env bash
# Run unit/integration tests
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

POGB_TESTROOT="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "$POGB_TESTROOT/../env.sh"
cd "$POGB_TESTROOT"

#echo "Running all unit tests ..."

echo "Running all integration tests with magic on ..."
export POG_CONFIG_MAGIC=1

shopt -s globstar
for f in int/**/*.bats; do
  shopt -u globstar
  bats "$f"
done
