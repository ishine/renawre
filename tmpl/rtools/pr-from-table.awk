# Evaluate keyword detections from table
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

NR==FNR {
  refs[$1] = "";
  for (i=2; i<=NF; i++) {
    # Record reference statistics
    if (ref[$1 " " $i] != 1 && length($i) > 0) {
      refs[$1] = refs[$1] " " $i;
    }
    ref[$1 " " $i]=1;
  }
  sub(/^ /, "", refs[$1]);
  next;
}

1 {
  hyps = "";
  for (i=2; i<=NF; i++) {
    # Record hypothesis statistics
    if (hyp[$i] != 1 && length($i) > 0) {
      hyps = hyps " " $i;
    }
    hyp[$i]=1;
  }
  sub(/^ /, "", hyps);

  # Check if there's a reference for this record
  if (!($1 in refs)) {
    print "Error: No reference for record " $1 > "/dev/stderr";
    exit 1;
  }

  # Try to find the statistics of current record
  split(refs[$1],arrRef," ")
  nRef = asort(arrRef);
  split(hyps,arrHyp," ")
  nHyp = asort(arrHyp);

  printf("%s", $1);

  # First, find TP
  for (i=1; i<=nRef; i++) {
    if (hyp[arrRef[i]] == 1) {
      printf(" TP:%s", arrRef[i]);
    }
  }

  # Find FR (in ref but not in hyp)
  for (i=1; i<=nRef; i++) {
    if (hyp[arrRef[i]] != 1) {
      printf(" FR:%s", arrRef[i]);
    }
  }

  # Find FA (in hyp but not in ref)
  for (i=1; i<=nHyp; i++) {
    if (ref[$1 " " arrHyp[i]] != 1) {
      printf(" FA:%s", arrHyp[i]);
    }
  }

  printf("\n");

  delete hyp;
  delete arrRef;
  delete arrHyp;
}
