#!/usr/bin/env bats
# Integration test: input-table
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

F="$(basename "$BATS_TEST_FILENAME" .bats)"
dest="$BATS_TEST_DIRNAME/../dest"

inputEmpty=
inputEmpty_nlines=0
read -d '' -r input1 <<"EOF" || true
A C D
B R T U
 I O P
EOF
input1_nlines=2

function runout {
  run "$@";
  local rslt=$status
  printf "Output of %s:\n%s\n" "$*" "$output" >&2
  return $rslt
}

function getvar {
  printf '%s' "${!1}"
  echo
  return $?
}

function docmp {
  runout diff -daur "$@"
  return $?
}

function setup {
  set -euo pipefail
  D="$(mktemp -d "/tmp/renawre.$F.tmp.XXXXXXXXXX")"
  echo "using temp dir: $D" >&2
}

function teardown {
  if [[ -n "${D:-}" && "${D:-}" == /tmp/* && -z ${BATS_ERROR_STATUS:-} ]]; then
    rm -rvf "${D}"
  fi
  unset D
  set +euo pipefail
}

@test "$F: input normal table" {
  runout $dest/table/table-input.sh out=$D <<< "$input1"
  docmp <(getvar input1) <(gunzip -c $D/table.gz)
}

@test "$F: input normal table from file" {
  runout $dest/table/table-input.sh out=$D --file=<(getvar input1)
  docmp <(getvar input1) <(gunzip -c $D/table.gz)
}

@test "$F: input empty table" {
  runout $dest/table/table-input.sh out=$D <<< "$inputEmpty"
  docmp <(getvar inputEmpty) <(gunzip -c $D/table.gz)
}

@test "$F: correct count of normal table" {
  runout $dest/table/table-input.sh out=$D <<< "$input1"
  docmp <(getvar input1_nlines) $D/_meta_nlines
}

@test "$F: correct count of empty table" {
  runout $dest/table/table-input.sh out=$D <<< "$inputEmpty"
  docmp <(getvar inputEmpty_nlines) $D/_meta_nlines
}
