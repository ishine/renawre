# Inverse table (value <-> key)
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
  if (startcol < 2) {
    startcol = 2;
  }
}

!/^ / {
  for(i=startcol; i<=NF; i++) {
    lst[$i]=lst[$i] " " $1
  }
}

END {
  for (k in lst) {
    print k lst[k]
  }
}
