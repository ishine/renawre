# Apply table to another table
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

BEGIN {
  if (startcol1 < 2) {
    startcol1 = 2; # this one is for mapping
  }
  if (startcol2 < 2) {
    startcol2 = 2; # this one is for input
  }
  if (strict == "") {
    strict = 1;
  }
  if (filler == "") {
    filler = " ";
  }
}

NR==FNR {
  if ($1 in d) next;
  if (/^ /) next;
  for (i=startcol1; i<=NF; i++) {
    d[$1]=d[$1] filler $i;
  }
  d[$1] = substr(d[$1], 2); # Eliminate first filler
  next
}

1 {
  for (i=startcol2; i<=NF; i++) {
    if ($i in d) {
      $i = d[$i];
    } else {
      if (strict == 1) {
        hasError = 1;
        if (!($i in reported)) {
          print "Not found in mapping: " $i " @line " FNR, $1 > "/dev/stderr"
        }
        reported[$i] = 1;
      }
    } # end if find matched entry
  } # end for all column
  print $0;
}

END {
  if (hasError == 1) exit 5;
}
