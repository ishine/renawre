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

source "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")/env.sh"

function buildone {
  local src="$1"
  local dest="$2"

  # Incase result is too old, rebuild it
  if [[ ! -f "$dest" || "$src" -nt "$dest"
      || "$POG_POGSOURCE/build.sh" -nt "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"
    "$POG_POGSOURCE/build.sh" "$src" > "$dest"
    chmod 755 "$dest"
  fi
}

function buildall {
  # Iterate over all buildable files
  local src;

  shopt -s globstar
  for src in src/**/*.sh; do
    local dest="${src/#src/dest}"

    # Do the build!
    buildone "$src" "$dest"
  done
  #buildone src/test/test1.sh dist/test/test1.sh
  shopt -u globstar
}

buildall
