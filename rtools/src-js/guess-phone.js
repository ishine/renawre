// Guess phonemes from existing lexicon
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

// TODO: semantics between undefined and [] is blur

const fs = require('fs');
const es = require('event-stream');
const sprintf = require("sprintf-js").sprintf
const product = require('cartesian-product');
const unzip = require('compute-unzip');
const pinyin = require("chinese-to-pinyin");

if (process.argv.length < 3) {
  console.error('Usage: $0 lexicon-file');
  process.exit(3);
}

// Regexs
const reIsAscii = /^[\x00-\x7F]+$/;
const rePureSymbol = /^[^A-Za-z]+$/;
const reSepSil = /[-_,\/:;]/;
const reSepAt = /[@]/;
const reSepDot = /[.]/;
const reSepAnd = /[&]/;

// return something like this [
//   [[0.92, 'phone1 phone2'], [0.87, 'phone1 phone3']],
//   [[1.0, 'phone4 phone5']]
// ];
function guessPron(word) {
  if (word in lex) return [lex[word]];
  if (word.length == 0) return [];
  if (reIsAscii.test(word)) {
    return guessAsciiPron(word);
  } else {
    return guessUniPron(word);
  }
}

function guessAsciiPron(word) {
  if (rePureSymbol.test(word)) { // pure symbol
    return [[[1.0, 'SIL']]]

  } else if (reSepSil.test(word)) { // have silence separator
    return [].concat.apply([], word.split(reSepSil).map(guessPron));

  } else if (reSepAt.test(word)) { // have @ separator, like @me
    return [].concat.apply([], word.split(reSepAt).map(guessPron)
                           .map(insertSeparator.bind(null, 'AE T')));

  } else if (reSepDot.test(word)) { // have . separator, like www.com
    return [].concat.apply([], word.split(reSepDot).map(guessPron)
                           .map(insertSeparator.bind(null, 'D AA T')));

  } else if (reSepAnd.test(word)) { // have & separator, like AT&T
    return [].concat.apply([], word.split(reSepAnd).map(guessPron)
                           .map(insertSeparator.bind(null, 'AE N')));

  } else if (word.length <= 4) { // Maybe an abbr
    return word.split('').map((alphabet) => lex[alphabet + '.']);

  } else { // try splitting the word arbitrarily
    for (let i=2; i<word.length-1; i++) {
      const w1 = lex[word.substring(0, i)];
      const w2 = lex[word.substring(i)];
      if (w1 !== undefined && w2 !== undefined) {
        return [w1, w2];
      }
    }
  }
  return [];
}

function guessUniPron(word) {
  // Guess from shorter words
  for (let i=1; i<word.length; i++) {
    if (word.substring(0, word.length-i) in lex) {
      const w1 = lex[word.substring(0, word.length-i)];
      const w2 = guessPron(word.substring(word.length-i));
      if (w1 !== undefined && w2 !== undefined && w2.length > 0) {
        return [w1].concat(w2);
      }
    }
  }
  return pinyin(word, {numberTone: true}).split(' ').map((v) => [[1.0, v]]);
}

// Take an array of possible array of pron tuples
// return an array of all pronunciation combinations
function combinePron(possibility) {
  const validPossibility = possibility.filter((vs) => vs.length>0);
  if (validPossibility.length == 0) return [];

  return product(validPossibility).map((vs) => {
      const [weights, prons] = unzip(vs);
      // Average score and concatenated pronunciation
      const validWeights = weights.filter((v) => v !== -99);
      return [
        validWeights.reduce((l,r) => l+r)/validWeights.length,
        prons.join(' ')
      ];
    });
}

// Read lexicon, brute force approach,
// but we need the whole lexicon in memory after all
const lex = fs.readFileSync(process.argv[2], 'utf-8')
    .toString()
    .split(/[\n\r]+/)
    .reduce(function (obj, line) {
      const cols = line.split(/ +([0-9.-]+) +(.+)/);
      const word = cols[0];
      const prob = parseFloat(cols[1]);
      const pron = cols[2];
      if (cols.length > 2) {
        if (word in obj) {
          obj[word].push([prob, pron])
        } else {
          obj[word] = [[prob, pron]];
        }
      }
    return obj;
  }, {});

// Processing input data
// We passthrough those with multiple columns (already done)
// Only guess those with one column (not yet done)
// Start processing the input data
process.stdin
  .pipe(es.split())
  .pipe(es.mapSync(function(line) {
    if (line.length === 0) { // empty line, skip
      return;
    }
    const cols = line.split(/ +(.+)/);
    if (cols.length > 1) { // already have pron, skip
      return;
    }

    const word = cols[0];
    const pronPossibilities = guessPron(word);
    const probAndProns = combinePron(pronPossibilities);
    for (let [prob, pron] of probAndProns) {
      console.log(sprintf('%s %.4f %s', word, prob, pron));
    }
    // If it failed, just passthrough the original word
    if (probAndProns.length == 0) {
      console.error('guess-phone.js: cannot guess pron of ' + word);
      console.log(word);
    }
  }));


// Misc things
function insertSeparator(sep, arr, idx) {
  if (idx == 0) return arr;
  return [[[-99, sep]]].concat(arr)
}
