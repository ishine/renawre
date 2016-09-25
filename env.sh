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

if [[ -z "${POGB_ISINCLUDED_RENAWREENV-}" ]]; then
  export POGB_ISINCLUDED_RENAWREENV=1
  export RENAWRE_ROOT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

  if [[ -f "$RENAWRE_ROOT/local.sh" ]]; then
    source "$RENAWRE_ROOT/local.sh"
  fi

  # Attempt to find POG if not specified
  if [[ ! -n "${POGB_POGSOURCE-}" ]]; then
    if [[ -f "$RENAWRE_ROOT/../probable-octo-guacamole/env.sh" ]]; then
      POGB_POGSOURCE="$RENAWRE_ROOT/../probable-octo-guacamole"
    elif [[ -f "$HOME/probable-octo-guacamole/env.sh" ]]; then
      POGB_POGSOURCE="$HOME/probable-octo-guacamole"
    else
      echo 'Error: cannot find POG' 1>&2
      exit 2
    fi
  fi
  source "$POGB_POGSOURCE/env.sh"

  addRoot RENAWRE "${RENAWRE_ROOT}"
fi # end if not defined yet
