#!/usr/bin/env bash
# Base env setup
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

export RENAWRE_ROOT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Attempt to find POG, based on where I usually put my file
if [[ -f "$RENAWRE_ROOT/../probable-octo-guacamole/env.sh" ]]; then
  POGB_PARENTROOT="$RENAWRE_ROOT/../probable-octo-guacamole"
elif [[ -f "$HOME/probable-octo-guacamole/env.sh" ]]; then
  POGB_PARENTROOT="$HOME/probable-octo-guacamole"
else
  echo 'Error: cannot find POG' 1>&2
  exit 2
fi

export POGB_VERSIONINFO__RENAWRE="$(git --git-dir="${RENAWRE_ROOT}/.git" describe --tags --long 2>/dev/null || echo unknown)"

if [[ -f "$RENAWRE_ROOT/local.sh" ]]; then
  source "$RENAWRE_ROOT/local.sh"
fi

source "$POGB_PARENTROOT/env.sh"
export POGB_ROOTLIST="$RENAWRE_ROOT/tmpl:${POGB_ROOTLIST:-}"
export POGB_BUILDLIST="$RENAWRE_ROOT/src:${POGB_BUILDLIST:-}"

# Attempt to find hs-nlp-accessories
if [[ -f "$RENAWRE_ROOT/../hs-nlp-accessories/stack.yaml" ]]; then
  export POGB_ROOTLIST="$RENAWRE_ROOT/../hs-nlp-accessories/dist:$POGB_ROOTLIST"
elif [[ -f "$HOME/hs-nlp-accessories/stack.yaml" ]]; then
  export POGB_ROOTLIST="$HOME/hs-nlp-accessories/dist:$POGB_ROOTLIST"
fi
