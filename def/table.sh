#!/usr/bin/env bash
# Definition of the base table object
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

source !.def/data.sh

# ========== Base object and flow function ========== #

function POGDef::table {
  local classname="$FUNCNAME"
  local objname="$1"

  POGDef::data "$objname"
  pogInjectMethods "$classname" "$objname"
}

function POGDef::table::preCheck {
  local this="$1"
  local dir="${!this}"
  if [[ -x "${dir}/get.sh" ]]; then
    return 0;
  fi
  if [[ -f "${dir}/table.gz" ]]; then
    return 0
  fi
  printError "input table $dir doesn't seem to exist"
  return 1;
}

function POGDef::table::saveMetadata {
  local this="${1}"
  $this::getNLine 1 > "${!this}/_meta_nlines"
  return 0
}

function POGDef::table::cleanUp {
  local this="${!1}"
  rm -f "${this}/get.sh" "${this}/table.gz"
  return 0
}

# ========== Write data ========== #

function POGDef::table::sink {
  local this="${1}"
  local dir="${!this}"
  local idGetter="${2:-get}"
  $this::outputFilter \
    | gzip -nc9 > "${dir}/table.gz"
}

function POGDef::table::getOutputFilter {
  printf '%s' "sed -r 's/ +\$//; s/\s+/ /g;'"
}

# ========== Getter ========== #

function POGDef::table::getGetter {
  local this="$1"
  local dir="${!this}"
  local idGetter="${2:-get}"
  local basePath="${3:-$dir}"

  if [[ -x "${dir}/${idGetter}.sh" ]]; then
    printf '%s' "bash '${basePath}/${idGetter}.sh' --nofilter"
    return $?
  fi
  if [[ -f "${dir}/table.gz" ]]; then
    printf '%s' "gunzip -c '${basePath}/table.gz'"
    return $?
  fi

  printError "Failed to get getter from $dir"
  return 1;
}

# ========== Type-specific ========== #

function POGDef::table::getNLine {
  local this="$1"
  local dir="${!this}"
  local forced="${2:-0}"
  if [[ -f "$dir/_meta_nlines" && $forced != 1 ]]; then
    cat "$dir/_meta_nlines"
  else
    $this::get \
      | awk 'NF > 1 && !/^ / {count+=1} END {print count}'
  fi
  return 0
}

function POGDef::table::transpose {
  local this="$1"
  local startcol="${2:-2}"
  $this::get \
    | awk -v startcol=$startcol \
    '!/^ / {for(i=startcol; i<=NF; i++) lst[$i]=lst[$i] " " $1} END {for (k in lst) print k lst[k]}'
}

function POGDef::table::getApplier {
  local this="$1"
  local that="$2"
  local target="$3" # the "output"
  local strict="${4:-1}"
  local filler="${5:- }"
  local thisColStart="${6:-2}"
  local thatColStart="${7:-2}"
  local nameGetter="${8:-}"
  cat <<"OUTEREOF"
read -d '' -r awkcmd <<"EOF" || true
NR==FNR {
  for (i=s2; i<=NF; i++) d[$1]=d[$1] filler $i;
  d[$1] = substr(d[$1], 2);
  next
}
1 {
  for (i=s1; i<=NF; i++) if ($i in d) {
    $i = d[$i];
  } else {
    if (strict == 1) {
      hasError = 1;
      print "Not found in mapping: " $i > "/dev/stderr";
    }
  }
  print $0;
}
END {
  if (hasError == 1) exit 5;
}
EOF
OUTEREOF

  $this::getRelGetter "$nameGetter" "$target"
  cat <<EOF
| awk -v s1=$thisColStart -v s2=$thatColStart -v filler="$filler" -v strict=$strict \
"\$awkcmd" <($($that::getRelGetter "$nameGetter" "$target")) /dev/stdin
EOF
}

function POGDef::table::checkInSet {
  local this="$1"
  local that="$2"
  local thisColStart="${3:-2}"
  read -d '' -r awkcmd <<"EOF" || true
    NR==FNR {
      if (!/^ /) d[$1]=1;
      next;
    }
    1 {
      for (i=s1; i<=NF; i++) if (!($i in d)) {
        hasError = 1;
        if (!($i in reported)) print "Not found in set: " $i " @line " FNR, $1 > "/dev/stderr";
        reported[$i] = 1;
      }
    }
    END {
      if (hasError == 1) exit 5;
    }
EOF

  $this::get \
    | awk -v s1=$thisColStart \
    "$awkcmd" <($that::get) /dev/stdin
}
