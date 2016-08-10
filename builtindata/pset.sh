#!/usr/bin/env bash
# Some builtin phone sets
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

declare -A _psets

set +e # Since read do return 1 on EOF

read -d '' -r _psets['ipa-ce'] <<'EOPS'
{ nonsil
@ nonsil
@` nonsil
1 nonsil
a nonsil
b nonsil
d nonsil
D nonsil
e nonsil
E nonsil
f nonsil
g nonsil
h nonsil
i nonsil
i: nonsil
j nonsil
k nonsil
l nonsil
L nonsil
m nonsil
M nonsil
n nonsil
N nonsil
o nonsil
O nonsil
O: nonsil
p nonsil
r\ nonsil
s nonsil
s` nonsil
s\ nonsil
S nonsil
t nonsil
T nonsil
t_h nonsil
u nonsil
u: nonsil
v nonsil
w nonsil
y nonsil
z nonsil
z` nonsil
Z nonsil
EOPS

read -d '' -r _psets['if+cmu-tone'] <<'EOPS'
AA nonsil
AE nonsil
AH nonsil
AO nonsil
AW nonsil
AY nonsil
B nonsil
CH nonsil
D nonsil
DH nonsil
EH nonsil
ER nonsil
EY nonsil
F nonsil
G nonsil
HH nonsil
IH nonsil
IY nonsil
JH nonsil
K nonsil
L nonsil
M nonsil
N nonsil
NG nonsil
OW nonsil
OY nonsil
P nonsil
R nonsil
S nonsil
SH nonsil
T nonsil
TH nonsil
UH nonsil
UW nonsil
V nonsil
W nonsil
Y nonsil
Z nonsil
ZH nonsil
a1 nonsil
a2 nonsil
a3 nonsil
a4 nonsil
a5 nonsil
ai1 nonsil
ai2 nonsil
ai3 nonsil
ai4 nonsil
ai5 nonsil
an1 nonsil
an2 nonsil
an3 nonsil
an4 nonsil
an5 nonsil
ang1 nonsil
ang2 nonsil
ang3 nonsil
ang4 nonsil
ang5 nonsil
ao1 nonsil
ao2 nonsil
ao3 nonsil
ao4 nonsil
ao5 nonsil
b nonsil
c nonsil
ch nonsil
d nonsil
e1 nonsil
e2 nonsil
e3 nonsil
e4 nonsil
e5 nonsil
ei1 nonsil
ei2 nonsil
ei3 nonsil
ei4 nonsil
ei5 nonsil
empt11 nonsil
empt12 nonsil
empt13 nonsil
empt14 nonsil
empt15 nonsil
empt21 nonsil
empt22 nonsil
empt23 nonsil
empt24 nonsil
empt25 nonsil
en1 nonsil
en2 nonsil
en3 nonsil
en4 nonsil
en5 nonsil
eng1 nonsil
eng2 nonsil
eng3 nonsil
eng4 nonsil
eng5 nonsil
er1 nonsil
er2 nonsil
er3 nonsil
er4 nonsil
er5 nonsil
f nonsil
g nonsil
h nonsil
i1 nonsil
i2 nonsil
i3 nonsil
i4 nonsil
i5 nonsil
ia1 nonsil
ia2 nonsil
ia3 nonsil
ia4 nonsil
ia5 nonsil
ian1 nonsil
ian2 nonsil
ian3 nonsil
ian4 nonsil
ian5 nonsil
iang1 nonsil
iang2 nonsil
iang3 nonsil
iang4 nonsil
iang5 nonsil
iao1 nonsil
iao2 nonsil
iao3 nonsil
iao4 nonsil
iao5 nonsil
ie1 nonsil
ie2 nonsil
ie3 nonsil
ie4 nonsil
ie5 nonsil
in1 nonsil
in2 nonsil
in3 nonsil
in4 nonsil
in5 nonsil
ing1 nonsil
ing2 nonsil
ing3 nonsil
ing4 nonsil
ing5 nonsil
iong1 nonsil
iong2 nonsil
iong3 nonsil
iong4 nonsil
iong5 nonsil
iu1 nonsil
iu2 nonsil
iu3 nonsil
iu4 nonsil
iu5 nonsil
j nonsil
k nonsil
l nonsil
m nonsil
n nonsil
o1 nonsil
o2 nonsil
o3 nonsil
o4 nonsil
o5 nonsil
ou1 nonsil
ou2 nonsil
ou3 nonsil
ou4 nonsil
ou5 nonsil
p nonsil
q nonsil
r nonsil
s nonsil
sh nonsil
sic nonsil
t nonsil
u1 nonsil
u2 nonsil
u3 nonsil
u4 nonsil
u5 nonsil
ua1 nonsil
ua2 nonsil
ua3 nonsil
ua4 nonsil
ua5 nonsil
uai1 nonsil
uai2 nonsil
uai3 nonsil
uai4 nonsil
uai5 nonsil
uan1 nonsil
uan2 nonsil
uan3 nonsil
uan4 nonsil
uan5 nonsil
uang1 nonsil
uang2 nonsil
uang3 nonsil
uang4 nonsil
uang5 nonsil
ueng1 nonsil
ueng2 nonsil
ueng3 nonsil
ueng4 nonsil
ueng5 nonsil
ui1 nonsil
ui2 nonsil
ui3 nonsil
ui4 nonsil
ui5 nonsil
un1 nonsil
un2 nonsil
un3 nonsil
un4 nonsil
un5 nonsil
uo1 nonsil
uo2 nonsil
uo3 nonsil
uo4 nonsil
uo5 nonsil
v1 nonsil
v2 nonsil
v3 nonsil
v4 nonsil
v5 nonsil
van1 nonsil
van2 nonsil
van3 nonsil
van4 nonsil
van5 nonsil
ve1 nonsil
ve2 nonsil
ve3 nonsil
ve4 nonsil
ve5 nonsil
vn1 nonsil
vn2 nonsil
vn3 nonsil
vn4 nonsil
vn5 nonsil
x nonsil
z nonsil
zh nonsil
 share an1 an2 an3 an4 an5
 share ang1 ang2 ang3 ang4 ang5
 share e1 e2 e3 e4 e5
 share empt11 empt12 empt13 empt14 empt15
 share empt21 empt22 empt23 empt24 empt25
 share en1 en2 en3 en4 en5
 share eng1 eng2 eng3 eng4 eng5
 share ia1 ia2 ia3 ia4 ia5
 share ian1 ian2 ian3 ian4 ian5
 share iang1 iang2 iang3 iang4 iang5
 share iao1 iao2 iao3 iao4 iao5
 share ie1 ie2 ie3 ie4 ie5
 share in1 in2 in3 in4 in5
 share ing1 ing2 ing3 ing4 ing5
 share iong1 iong2 iong3 iong4 iong5
 share iu1 iu2 iu3 iu4 iu5
 share ua1 ua2 ua3 ua4 ua5
 share uai1 uai2 uai3 uai4 uai5
 share uan1 uan2 uan3 uan4 uan5
 share uang1 uang2 uang3 uang4 uang5
 share ueng1 ueng2 ueng3 ueng4 ueng5
 share ui1 ui2 ui3 ui4 ui5
 share un1 un2 un3 un4 un5
 share uo1 uo2 uo3 uo4 uo5
 share v1 v2 v3 v4 v5
 share van1 van2 van3 van4 van5
 share ve1 ve2 ve3 ve4 ve5
 share vn1 vn2 vn3 vn4 vn5
 share AA a1 a2 a3 a4 a5
 share AO o1 o2 o3 o4 o5
 share AW ao1 ao2 ao3 ao4 ao5
 share AY ai1 ai2 ai3 ai4 ai5
 share B b
 share D d
 share ER er1 er2 er3 er4 er5
 share EY ei1 ei2 ei3 ei4 ei5
 share F f
 share HH h
 share IH i1 i2 i3 i4 i5
 share K k
 share L l
 share M m
 share N n
 share OW ou1 ou2 ou3 ou4 ou5
 share P p
 share S s
 share SH sh
 share T t
 share UW u1 u2 u3 u4 u5
 question b p m f d t n l g k h j q x zh ch sh r z c s sic
 question b p m f
 question d t n l
 question g k h
 question j q x
 question zh ch sh r
 question z c s
 question i1 i2 i3 i4 i5 u1 u2 u3 u4 u5 v1 v2 v3 v4 v5 a1 a2 a3 a4 a5 o1 o2 o3 o4 o5 e1 e2 e3 e4 e5 ai1 ai2 ai3 ai4 ai5 ei1 ei2 ei3 ei4 ei5 ao1 ao2 ao3 ao4 ao5 ou1 ou2 ou3 ou4 ou5 an1 an2 an3 an4 an5 en1 en2 en3 en4 en5 ang1 ang2 ang3 ang4 ang5 eng1 eng2 eng3 eng4 eng5 er1 er2 er3 er4 er5 empt11 empt12 empt13 empt14 empt15 empt21 empt22 empt23 empt24 empt25 ia1 ia2 ia3 ia4 ia5 ie1 ie2 ie3 ie4 ie5 iao1 iao2 iao3 iao4 iao5 iu1 iu2 iu3 iu4 iu5 ian1 ian2 ian3 ian4 ian5 in1 in2 in3 in4 in5 iang1 iang2 iang3 iang4 iang5 ing1 ing2 ing3 ing4 ing5 ua1 ua2 ua3 ua4 ua5 uo1 uo2 uo3 uo4 uo5 uai1 uai2 uai3 uai4 uai5 ui1 ui2 ui3 ui4 ui5 uan1 uan2 uan3 uan4 uan5 un1 un2 un3 un4 un5 uang1 uang2 uang3 uang4 uang5 ueng1 ueng2 ueng3 ueng4 ueng5 ve1 ve2 ve3 ve4 ve5 van1 van2 van3 van4 van5 vn1 vn2 vn3 vn4 vn5 iong1 iong2 iong3 iong4 iong5
 question i1 i2 i3 i4 i5 u1 u2 u3 u4 u5 v1 v2 v3 v4 v5 a1 a2 a3 a4 a5 o1 o2 o3 o4 o5 e1 e2 e3 e4 e5 ai1 ai2 ai3 ai4 ai5 ei1 ei2 ei3 ei4 ei5 ao1 ao2 ao3 ao4 ao5 ou1 ou2 ou3 ou4 ou5 an1 an2 an3 an4 an5 en1 en2 en3 en4 en5 ang1 ang2 ang3 ang4 ang5 eng1 eng2 eng3 eng4 eng5 er1 er2 er3 er4 er5 empt11 empt12 empt13 empt14 empt15 empt21 empt22 empt23 empt24 empt25
 question i1 i2 i3 i4 i5 u1 u2 u3 u4 u5 v1 v2 v3 v4 v5
 question empt11 empt12 empt13 empt14 empt15 empt21 empt22 empt23 empt24 empt25
 question a1 a2 a3 a4 a5 o1 o2 o3 o4 o5 e1 e2 e3 e4 e5
 question ai1 ai2 ai3 ai4 ai5 ei1 ei2 ei3 ei4 ei5 ao1 ao2 ao3 ao4 ao5 ou1 ou2 ou3 ou4 ou5
 question an1 an2 an3 an4 an5 en1 en2 en3 en4 en5 ang1 ang2 ang3 ang4 ang5 eng1 eng2 eng3 eng4 eng5
 question i1 i2 i3 i4 i5 u1 u2 u3 u4 u5 v1 v2 v3 v4 v5 ia1 ia2 ia3 ia4 ia5 ie1 ie2 ie3 ie4 ie5 iao1 iao2 iao3 iao4 iao5 iu1 iu2 iu3 iu4 iu5 ian1 ian2 ian3 ian4 ian5 in1 in2 in3 in4 in5 iang1 iang2 iang3 iang4 iang5 ing1 ing2 ing3 ing4 ing5 ua1 ua2 ua3 ua4 ua5 uo1 uo2 uo3 uo4 uo5 uai1 uai2 uai3 uai4 uai5 ui1 ui2 ui3 ui4 ui5 uan1 uan2 uan3 uan4 uan5 un1 un2 un3 un4 un5 uang1 uang2 uang3 uang4 uang5 ueng1 ueng2 ueng3 ueng4 ueng5 ve1 ve2 ve3 ve4 ve5 van1 van2 van3 van4 van5 vn1 vn2 vn3 vn4 vn5 iong1 iong2 iong3 iong4 iong5
 question i1 i2 i3 i4 i5 ia1 ia2 ia3 ia4 ia5 ie1 ie2 ie3 ie4 ie5 iao1 iao2 iao3 iao4 iao5 iu1 iu2 iu3 iu4 iu5 ian1 ian2 ian3 ian4 ian5 in1 in2 in3 in4 in5 iang1 iang2 iang3 iang4 iang5 ing1 ing2 ing3 ing4 ing5
 question ia1 ia2 ia3 ia4 ia5 ie1 ie2 ie3 ie4 ie5
 question iao1 iao2 iao3 iao4 iao5 iu1 iu2 iu3 iu4 iu5
 question ian1 ian2 ian3 ian4 ian5 in1 in2 in3 in4 in5 iang1 iang2 iang3 iang4 iang5 ing1 ing2 ing3 ing4 ing5
 question u1 u2 u3 u4 u5 ua1 ua2 ua3 ua4 ua5 uo1 uo2 uo3 uo4 uo5 uai1 uai2 uai3 uai4 uai5 ui1 ui2 ui3 ui4 ui5 uan1 uan2 uan3 uan4 uan5 un1 un2 un3 un4 un5 uang1 uang2 uang3 uang4 uang5 ueng1 ueng2 ueng3 ueng4 ueng5
 question ua1 ua2 ua3 ua4 ua5 uo1 uo2 uo3 uo4 uo5
 question uai1 uai2 uai3 uai4 uai5 ui1 ui2 ui3 ui4 ui5
 question uan1 uan2 uan3 uan4 uan5 un1 un2 un3 un4 un5 uang1 uang2 uang3 uang4 uang5 ueng1 ueng2 ueng3 ueng4 ueng5
 question ve1 ve2 ve3 ve4 ve5 van1 van2 van3 van4 van5 vn1 vn2 vn3 vn4 vn5 iong1 iong2 iong3 iong4 iong5
 question van1 van2 van3 van4 van5 vn1 vn2 vn3 vn4 vn5 iong1 iong2 iong3 iong4 iong5
 question ia1 ia2 ia3 ia4 ia5 ua1 ua2 ua3 ua4 ua5
 question ie1 ie2 ie3 ie4 ie5 ve1 ve2 ve3 ve4 ve5
 question ian1 ian2 ian3 ian4 ian5 uan1 uan2 uan3 uan4 uan5 van1 van2 van3 van4 van5
 question in1 in2 in3 in4 in5 un1 un2 un3 un4 un5 vn1 vn2 vn3 vn4 vn5
 question iang1 iang2 iang3 iang4 iang5 uang1 uang2 uang3 uang4 uang5
 question ing1 ing2 ing3 ing4 ing5 ueng1 ueng2 ueng3 ueng4 ueng5 iong1 iong2 iong3 iong4 iong5
 question an1 an2 an3 an4 an5 en1 en2 en3 en4 en5 ian1 ian2 ian3 ian4 ian5 in1 in2 in3 in4 in5 uan1 uan2 uan3 uan4 uan5 un1 un2 un3 un4 un5 van1 van2 van3 van4 van5 vn1 vn2 vn3 vn4 vn5
 question ang1 ang2 ang3 ang4 ang5 eng1 eng2 eng3 eng4 eng5 iang1 iang2 iang3 iang4 iang5 ing1 ing2 ing3 ing4 ing5 uang1 uang2 uang3 uang4 uang5 ueng1 ueng2 ueng3 ueng4 ueng5 vn1 vn2 vn3 vn4 vn5 iong1 iong2 iong3 iong4 iong5
 question AA AE AH AO AW AY EH ER EY IH IY OW OY UH UW Y
 question AA AE AH AO AW AY
 question EH ER EY
 question IH IY Y
 question OW OY
 question UH UW
 question B CH D DH F G HH JH K L M N NG P R S SH T TH V W Y Z ZH
 question M N NG
 question DH F S SH TH V Z ZH
 question L R
 question M N NG
 question W Y
 question B D G K P T
EOPS

read -d '' -r _psets['if+cmu'] <<'EOPS'
AA nonsil
AE nonsil
AH nonsil
AO nonsil
AW nonsil
AY nonsil
B nonsil
CH nonsil
D nonsil
DH nonsil
EH nonsil
ER nonsil
EY nonsil
F nonsil
G nonsil
HH nonsil
IH nonsil
IY nonsil
JH nonsil
K nonsil
L nonsil
M nonsil
N nonsil
NG nonsil
OW nonsil
OY nonsil
P nonsil
R nonsil
S nonsil
SH nonsil
T nonsil
TH nonsil
UH nonsil
UW nonsil
V nonsil
W nonsil
Y nonsil
Z nonsil
ZH nonsil
a nonsil
ai nonsil
an nonsil
ang nonsil
ao nonsil
b nonsil
c nonsil
ch nonsil
d nonsil
e nonsil
ei nonsil
empt1 nonsil
empt2 nonsil
en nonsil
eng nonsil
er nonsil
f nonsil
g nonsil
h nonsil
i nonsil
ia nonsil
ian nonsil
iang nonsil
iao nonsil
ie nonsil
in nonsil
ing nonsil
iong nonsil
iu nonsil
j nonsil
k nonsil
l nonsil
m nonsil
n nonsil
o nonsil
ou nonsil
p nonsil
q nonsil
r nonsil
s nonsil
sh nonsil
sic nonsil
t nonsil
u nonsil
ua nonsil
uai nonsil
uan nonsil
uang nonsil
ueng nonsil
ui nonsil
un nonsil
uo nonsil
v nonsil
van nonsil
ve nonsil
vn nonsil
x nonsil
z nonsil
zh nonsil
 share AA a
 share AO o
 share AW ao
 share AY ai
 share B b
 share D d
 share ER er
 share EY ei
 share F f
 share HH h
 share IH i
 share K k
 share L l
 share M m
 share N n
 share OW ou
 share P p
 share S s
 share SH sh
 share T t
 share UW u
 question b p m f d t n l g k h j q x zh ch sh r z c s sic
 question b p m f
 question d t n l
 question g k h
 question j q x
 question zh ch sh r
 question z c s
 question i u v a o e ai ei ao ou an en ang eng er empt1 empt2 ia ie iao iu ian in iang ing ua uo uai ui uan un uang ueng ve van vn iong
 question i u v a o e ai ei ao ou an en ang eng er empt1 empt2
 question i u v
 question empt1 empt2
 question a o e
 question ai ei ao ou
 question an en ang eng
 question i u v ia ie iao iu ian in iang ing ua uo uai ui uan un uang ueng ve van vn iong
 question i ia ie iao iu ian in iang ing
 question ia ie
 question iao iu
 question ian in iang ing
 question u ua uo uai ui uan un uang ueng
 question ua uo
 question uai ui
 question uan un uang ueng
 question ve van vn iong
 question van vn iong
 question ia ua
 question ie ve
 question ian uan van
 question in un vn
 question iang uang
 question ing ueng iong
 question an en ian in uan un van vn
 question ang eng iang ing uang ueng vn iong
 question AA AE AH AO AW AY EH ER EY IH IY OW OY UH UW Y
 question AA AE AH AO AW AY
 question EH ER EY
 question IH IY Y
 question OW OY
 question UH UW
 question B CH D DH F G HH JH K L M N NG P R S SH T TH V W Y Z ZH
 question M N NG
 question DH F S SH TH V Z ZH
 question L R
 question M N NG
 question W Y
 question B D G K P T
EOPS

read -d '' -r _psets['cmu'] <<'EOPS'
AA nonsil
AE nonsil
AH nonsil
AO nonsil
AW nonsil
AY nonsil
B nonsil
CH nonsil
D nonsil
DH nonsil
EH nonsil
ER nonsil
EY nonsil
F nonsil
G nonsil
HH nonsil
IH nonsil
IY nonsil
JH nonsil
K nonsil
L nonsil
M nonsil
N nonsil
NG nonsil
OW nonsil
OY nonsil
P nonsil
R nonsil
S nonsil
SH nonsil
T nonsil
TH nonsil
UH nonsil
UW nonsil
V nonsil
W nonsil
Y nonsil
Z nonsil
ZH nonsil
EOPS

set -e
