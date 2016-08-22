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

read -d '' -r input1 <<"EOF" || true
1 aa bb
2 bb cc
EOF

read -d '' -r lex1 <<"EOF" || true
aa p o i
bb l k u
cc m t b a
EOF

read -d '' -r ans_input1_lex1 <<"EOF" || true
1 p o i l k u
2 l k u m t b a
EOF

read -d '' -r ansplus_input1_lex1 <<"EOF" || true
1 p+o+i l+k+u
2 l+k+u m+t+b+a
EOF

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
  export POG_DATABASEDIR="$D/.data"
  echo "using temp dir: $D" >&2
}

function teardown {
  if [[ -n "${D:-}" && "${D:-}" == /tmp/* && -z ${BATS_ERROR_STATUS:-} ]]; then
    rm -rvf "${D}"
  fi
  unset D
  set +euo pipefail
}

function setdata {
  local input="$1"
  local lex="$2"
  runout $dest/table/table-input.sh out=$D/i <<< "${!input}" && \
    runout $dest/table/table-input.sh out=$D/l <<< "${!lex}"
  return $?
}

@test "$F: apply normal table" {
  setdata input1 lex1

  runout $dest/table/table-apply.sh in=$D/i map=$D/l out=$D/o
  docmp <(getvar ans_input1_lex1) <($D/o/get.sh)

  runout $dest/table/table-apply.sh --realize=1 in=$D/i map=$D/l out=$D/o
  docmp <(getvar ans_input1_lex1) <(gunzip -c $D/o/table.gz)
}

@test "$F: apply normal table, with filler" {
  setdata input1 lex1

  runout $dest/table/table-apply.sh --filler='+' in=$D/i map=$D/l out=$D/o
  docmp <(getvar ansplus_input1_lex1) <($D/o/get.sh)

  runout $dest/table/table-apply.sh --filler='+' --realize=1 in=$D/i map=$D/l out=$D/o
  docmp <(getvar ansplus_input1_lex1) <(gunzip -c $D/o/table.gz)
}
