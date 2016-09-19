// Prepare Chinese Gigaword text stories
// ***************************************************************************
//   Copyright 2014-2016, mettatw
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
// ***************************************************************************
'use strict';

const es = require('event-stream');
const parseString = require('xml2js').parseString;
const sprintf = require('sprintf-js').sprintf;

function normalizeText(input) {
  return input.trim()
    .replace(/[\n\r]+/g, '')
    .replace(/\s+/g, ' ');
}

let nameDict = new Object();
function dedupIdDoc(idDoc) {
  if (!nameDict.hasOwnProperty(idDoc)) {
    nameDict[idDoc] = 'a';
    return idDoc;
  }
  let rslt = idDoc + nameDict[idDoc];
  nameDict[idDoc] = String.fromCharCode(nameDict[idDoc].charCodeAt(0)+1);
  return rslt;
}

function parseDoc(input, cb) {
  let rslt = '';

  parseString(input, function (err, json) {
    if (err !== null || json.DOC === void 0 || json.DOC.TEXT === void 0) {
      cb(''); return 0;
    }
    const data = json.DOC;
    // Skip non-story things, or incomplete things
    if (data.$.type !== 'story' || data.HEADLINE === void 0 || data.TEXT === void 0) {
      cb(''); return 0;
    }
    const idDoc = dedupIdDoc(
      'CGW-' + data.$.id.replace(/_CMN_\d\d/, '').replace(/[._]/g, '-')
    );
    rslt += sprintf('%s✈head %s\n', idDoc, normalizeText(data.HEADLINE[0]));
    for (let i = 0; i < data.TEXT[0].P.length; i++) {
      let thisText = normalizeText(data.TEXT[0].P[i]);
      // If too many arabic numbers, skip this story
      let matchNum = thisText.match(/[0-9]{2,}/g);
      if (matchNum !== null && matchNum.length > 4) {
        cb(''); return 0;
      }
      rslt += sprintf('%s✈%d %s\n', idDoc, i, thisText);
    }
    cb(null, rslt);
  });
}

process.stdin
  .pipe(es.split('</DOC>'))
  .pipe(es.map(function(thisDoc, cb) {
    if (thisDoc.trim().length < 10) return;
    parseDoc(thisDoc + '</DOC>', cb);
  })).pipe(process.stdout);
