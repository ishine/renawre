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

_thisroot="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Attempt to find POG, based on where I usually put my file
if [[ -f "$_thisroot/../probable-octo-guacamole/env.sh" ]]; then
  POG_PARENTROOT="$_thisroot/../probable-octo-guacamole"
elif [[ -f "$HOME/probable-octo-guacamole/env.sh" ]]; then
  POG_PARENTROOT="$HOME/probable-octo-guacamole"
fi

export POG_VERSIONINFO__RENAWRE="$(git --git-dir="${_thisroot}/.git" describe --tags --long 2>/dev/null || echo unknown)"

if [[ -f "$_thisroot/local.sh" ]]; then
  source "$_thisroot/local.sh"
fi

source "$POG_PARENTROOT/env.sh"

export POG_ROOTLIST="$_thisroot:$POG_ROOTLIST"

