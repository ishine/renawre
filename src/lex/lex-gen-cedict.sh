#!/usr/bin/env bash
# Prepare CEDict Mandarin pronounciation dictionary
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

out= !!lex:o:c

!@beginscript

URL='https://www.mdbg.net/chindict/export/cedict/cedict_1_0_ts_utf-8_mdbg.txt.gz'
CACHEFILE="${POG_CACHEDIR}/share/cedict"
mkdir -p "$(dirname "${CACHEFILE}")"
if [[ ! -f "${CACHEFILE}" ]]; then
  wget -nv -O "${CACHEFILE}" "$URL"
fi # end if there's no cached file

# awk delete comments and non-mandarin words and punctuations (cleanup)
# perl formatting, getting only first col (zh-tw), and third col (pron)
# awk delete duplicate and delete too-long words
# Also apply some pronunciation fixes
gunzip -c "$CACHEFILE" \
  | awk '!/^\s*#/ && !($1 ~ /[a-zA-Z0-9]/) && !($1 ~ /[、。，·,・.%�]/) && !/xx5/' \
  | perl -CSAD -lpe 's/^([^ ]+) [^ ]+ \[([^\]]*)\] .*/\1 1.0000 \L\2/' \
  | awk '!a[$0]++ && length($1) <= 5' \
  | awk 'NR==FNR {a[$1 "," $3] = $2; next} 1{if($1 "," $3 in a) $2=a[$1 "," $3]}1' <(cat <<"EOF"
上 0.2000 shang3
中 0.5000 zhong4
丼 0.2000 jing3
乘 0.1000 sheng4
乙 0.0000 zhe2
亁 0.1000 qian2
了 0.8000 le5
什 0.1000 shi2
仇 0.0000 qiu2
仔 0.1000 zi1
仔 0.1000 zi3
令 0.0000 ling2
令 0.0000 ling3
伯 0.0000 ba4
伯 0.0000 bai3
估 0.0000 gu4
伺 0.6000 ci4
似 0.2000 shi4
佃 0.0000 tian2
佚 0.1000 die2
作 0.1000 zuo1
供 0.7000 gong4
俊 0.1000 zun4
俞 0.0000 shu4
俟 0.0000 qi2
倘 0.0500 chang2
倞 0.0000 liang4
倥 0.0500 kong1
偈 0.4000 jie2
側 0.0000 zhai1
價 0.0000 jie5
免 0.0000 wen4
冠 0.3000 guan1
凹 0.0000 wa1
分 0.7000 fen4
切 0.7000 qie4
刨 0.7000 pao2
刷 0.0000 shua4
刺 0.0000 ci1
剋 0.0000 kei1
剌 0.0000 la2
創 0.0500 chuang1
剿 0.0000 chao1
劃 0.0000 hua2
劈 0.0500 pi3
劵 0.6500 quan4
勒 0.3000 lei1
勞 0.3000 lao4
勾 0.0000 gou4
化 0.1000 hua1
匱 0.0500 gui4
匹 0.3000 pi3
區 0.0500 ou1
卒 0.0000 cu4
占 0.7000 zhan1
卡 0.0000 qia3
卷 0.8000 juan4
參 0.3000 san1
參 0.0500 shen1
叉 0.0000 cha2
叉 0.0000 cha3
句 0.0500 gou1
叨 0.0500 tao1
召 0.0500 shao4
可 0.0000 ke4
吁 0.0000 yu4
合 0.0500 ge3
吒 0.4000 zha1
否 0.0500 pi3
吭 0.1000 hang2
呵 0.0000 a1
和 0.7000 he4
和 0.0000 hu2
和 0.0000 huo2
和 0.8000 huo4
咳 0.0000 hai1
唯 0.0000 wei3
啞 0.0500 ya1
喂 0.4000 wei2
喝 0.2000 he4
喪 0.6000 sang1
單 0.2000 shan4
地 0.2000 de5
埋 0.0000 man2
埔 0.2000 bu4
堡 0.0000 pu4
場 0.1000 chang2
塞 0.6000 sai4
塞 0.1000 se4
壓 0.0000 ya4
大 0.1000 dai4
夫 0.1000 fu2
夯 0.0000 ben4
夾 0.0000 jia1
夾 0.0000 jia4
奇 0.5000 ji1
奘 0.0000 zhuang3
女 0.0500 ru3
妳 0.0000 nai3
妻 0.0000 qi4
委 0.0500 wei1
姥 0.0000 mu3
娜 0.0000 nuo2
媁 0.0500 wei2
媛 0.0500 yuan4
嬛 0.0000 qiong2
嬛 0.0000 xuan1
子 0.8000 zi5
孱 0.4000 can4
宿 0.4000 xiu3
宿 0.1000 xiu4
寧 0.0300 ning4
將 0.6000 jiang4
將 0.0000 qiang1
尺 0.0000 che3
尾 0.0000 yi3
尿 0.0000 sui1
居 0.0000 ji1
屏 0.0000 bing1
屏 0.0000 bing3
屬 0.1000 zhu3
屯 0.0000 zhun1
峇 0.0000 ke1
峒 0.2000 tong2
嵌 0.0000 qian4
差 0.2000 cha4
差 0.7000 chai1
帖 0.1000 tie1
帖 0.0000 tie4
幢 0.0000 zhuang4
幾 0.2000 ji1
底 0.0000 de5
度 0.0000 duo2
廁 0.0000 si4
廈 0.1000 sha4
弄 0.1000 long4
弟 0.1000 ti4
強 0.2000 jiang4
強 0.0000 qiang3
彈 0.7000 dan4
彊 0.0000 qiang2
彊 0.0000 qiang3
彷 0.1000 pang2
得 0.3000 dei3
從 0.1000 zong4
徵 0.0000 zhi3
悶 0.2000 men4
惡 0.1000 e3
扁 0.1000 pian1
扒 0.8000 pa2
打 0.0000 da2
扛 0.0000 gang1
折 0.0000 she2
折 0.0000 zhe1
抹 0.1000 ma1
抹 0.0000 mo4
拂 0.1000 bi4
拓 0.1000 ta4
拗 0.0000 niu4
拚 0.0000 pan4
拽 0.0000 ye4
拽 0.0000 zhuai1
拽 0.0000 zhuai4
拾 0.0000 she4
挑 0.3000 tiao3
挨 0.0000 ai2
挾 0.7000 xie2
据 0.2000 ju4
掃 0.7000 sao4
掙 0.2000 zheng1
搶 0.0000 qiang1
摟 0.0000 lou1
摸 0.0000 mo2
摻 0.0000 shan3
撇 0.2000 pie1
撒 0.0000 sa1
撩 0.0000 liao1
操 0.0000 cao4
擰 0.5000 ning4
擱 0.0000 ge2
數 0.0000 shuo4
斂 0.0000 lian3
於 0.0000 wu1
於 0.0000 yu1
晃 0.0000 huang3
晟 0.2000 sheng4
暈 0.0000 yun4
曾 0.2000 zeng1
會 0.1000 kuai4
服 0.0000 fu4
朝 0.6000 zhao1
柏 0.0000 bai3
柏 0.0000 bo4
查 0.0000 zha1
校 0.6000 jiao4
楞 0.0000 leng2
榜 0.0000 bang4
檔 0.0000 dang4
檵 0.0000 qi3
檻 0.0000 jian4
正 0.2000 zheng1
歪 0.0000 wai3
殷 0.0000 yan1
殷 0.0000 yin3
比 0.0000 bi4
氏 0.1000 zhi1
氓 0.1000 meng2
汗 0.1000 han2
沈 0.1000 chen2
沉 0.0000 chen1
泊 0.0000 po1
泡 0.0000 pao1
泥 0.0000 ni4
涼 0.0000 liang4
淋 0.0000 lin4
混 0.1000 hun2
淺 0.0000 jian1
渠 0.0000 ju4
渦 0.0000 guo1
湮 0.3000 yin1
湯 0.0000 shang1
溺 0.0000 niao4
漸 0.3000 jian1
漿 0.0000 jiang4
澄 0.0000 deng4
澹 0.0000 tan2
瀑 0.0000 bao4
瀧 0.0000 shuang1
炮 0.0000 bao1
炮 0.2000 pao2
炸 0.2000 zha2
為 0.7000 wei2
煞 0.2000 sha1
熜 0.0000 cong1
熨 0.0000 yu4
熬 0.0000 ao1
燎 0.0000 liao3
燕 0.1000 yan1
爌 0.0000 huang3
爌 0.0000 kuang3
片 0.0000 pian1
牟 0.0000 mu4
王 0.0000 wang4
甚 0.0000 shen2
甬 0.0000 tong3
町 0.1000 ting3
番 0.0000 pan1
的 0.2000 di1
的 0.2000 di4
監 0.0000 jian4
盪 0.0000 tang4
省 0.7000 xing3
看 0.7000 kan1
瞭 0.0000 liao4
矇 0.1000 meng1
矯 0.1000 jiao2
石 0.2000 dan4
碌 0.0000 liu4
祭 0.0000 zhai4
禁 0.2000 jin1
禪 0.2000 shan4
禺 0.1000 ou3
禺 0.1000 yu4
秘 0.0000 bi4
秤 0.0000 cheng1
稍 0.0000 shao4
種 0.9000 zhong4
稱 0.5000 chen4
稱 0.5000 cheng4
稽 0.0000 qi3
答 0.2000 da1
節 0.0000 jie1
籠 0.1000 long3
粘 0.0000 zhan1
粥 0.0000 yu4
糊 0.0000 hu4
糜 0.0000 mei2
紀 0.0000 ji3
約 0.0000 yao1
紥 0.1000 zha1
累 0.5000 lei3
結 0.0000 jie1
絡 0.0000 lao4
給 0.6000 ji3
綜 0.0000 zeng4
綜 0.2000 zong1
綴 0.2000 chuo4
緝 0.0000 qi1
繫 0.1000 ji4
翟 0.2000 di2
翹 0.2000 qiao2
聽 0.1000 ting4
肖 0.1000 xiao1
肚 0.0000 du3
胖 0.0000 pan2
脈 0.1000 mo4
脯 0.1000 fu3
腳 0.1000 jue2
膀 0.0000 bang3
膀 0.0000 bang4
膀 0.0000 pang1
膏 0.0000 gao4
臊 0.0000 sao1
臭 0.1000 xiu4
與 0.1000 yu2
與 0.0000 yu4
興 0.6000 xing4
舍 0.2000 she3
般 0.0000 pan2
色 0.0000 shai3
艾 0.0000 yi4
芍 0.0000 que4
芥 0.0000 gai4
芯 0.0000 xin4
芸 0.0000 yi4
苔 0.6000 tai2
茜 0.1000 xi1
草 0.0000 cao4
荑 0.0000 ti2
莎 0.1000 suo1
莘 0.0000 shen1
莞 0.1000 guan1
莞 0.1000 guan3
莩 0.0000 piao3
菌 0.0000 jun1
華 0.3000 hua1
華 0.2000 hua4
菲 0.0000 fei3
菸 0.0000 yu1
落 0.0000 la4
落 0.5000 lao4
葛 0.4000 ge2
蒙 0.1000 meng1
蒙 0.0000 meng3
蓋 0.0000 ge3
蔓 0.0000 man2
蔚 0.0000 yu4
蕃 0.0000 bo1
蕃 0.1000 fan2
蕉 0.0000 qiao2
薄 0.7000 bao2
薄 0.2000 bo4
蘋 0.1000 pin2
蝦 0.0000 ha2
螞 0.0000 ma1
螞 0.0000 ma4
行 0.9000 hang2
術 0.0000 zhu2
衖 0.0000 xiang4
衝 0.2000 chong4
衣 0.0000 yi4
衰 0.0000 cui1
褚 0.0000 zhu3
褪 0.1000 tun4
褶 0.0000 xi2
襢 0.0000 zhan4
要 0.3000 yao1
覃 0.0000 qin2
見 0.0000 xian4
親 0.0000 qing4
覺 0.6000 jiao4
觀 0.0000 guan4
角 0.2000 jue2
解 0.0200 jie4
解 0.2000 xie4
語 0.0000 yu4
說 0.2000 shui4
調 0.7000 diao4
論 0.1000 lun2
謎 0.0000 mei4
謚 0.0000 shi4
識 0.0000 zhi4
讀 0.0000 dou4
豁 0.0000 hua2
豁 0.0000 huo1
賈 0.1000 gu3
賺 0.0000 zuan4
趟 0.0000 tang1
足 0.0000 ju4
跑 0.0000 pao2
踉 0.3000 liang2
踏 0.1000 ta1
蹌 0.3000 qiang1
蹶 0.3000 jue3
車 0.1000 ju1
軋 0.0000 zha2
軸 0.0000 zhou4
載 0.9000 zai3
轉 0.0000 zhuai3
轉 0.7000 zhuan4
轍 0.0000 zhe2
追 0.0000 dui1
通 0.0000 tong4
逮 0.0000 dai4
過 0.0000 guo5
遠 0.1000 yuan4
邊 0.0000 bian5
那 0.0000 nuo2
都 0.7000 du1
采 0.0000 cai4
鈀 0.4000 pa2
鉄 0.0000 zhi4
鋸 0.0000 ju1
鎬 0.1000 hao4
鐺 0.0000 cheng1
閒 0.0000 jian1
閒 0.0000 jian1
閤 0.0000 he2
闆 0.0000 pan4
闕 0.0000 que1
陂 0.0000 bei1
降 0.1000 xiang2
陸 0.0500 liu4
隆 0.0000 long1
隱 0.0000 yin4
雀 0.0000 qiao1
雋 0.0000 jun4
難 0.7000 nan4
雨 0.0000 yu4
靚 0.0000 liang4
頭 0.0000 tou5
食 0.0000 si4
飬 0.0000 yang3
飲 0.0000 yin4
馮 0.0000 ping2
騎 0.1000 ji4
鮮 0.4000 xian3
鳥 0.0000 diao3
鵠 0.0000 gu3
麗 0.0000 li2
齦 0.0000 ken3
EOF
) /dev/stdin \
  | out::sink
