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

const fs = require('fs');
const es = require('event-stream');
const sprintf = require("sprintf-js").sprintf
const product = require('cartesian-product');
const unzip = require('compute-unzip');

if (process.argv.length < 3) {
  console.error('Usage: $0 lexicon-file');
  process.exit(3);
}

function guessPron(word) {
  if (word in lex) return [lex[word]];
  return [
    [[0.92, 'AC C'], [0.87, 'Q Q A']],
    [[1.0, 'Z H']]
  ];
}

// Take an array of possible array of pron tuples
// return an array of all pronunciation combinations
function combinePron(possibility) {
  return product(possibility).map((vs) => {
    const [weights, prons] = unzip(vs);
    // Average score and concatenated pronunciation
    return [weights.reduce((l,r) => l+r)/weights.length, prons.join(' ')];
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

console.log(lex);

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
    for (let [prob, pron] of combinePron(pronPossibilities)) {
      console.log(sprintf('%s %.4f %s', word, prob, pron))
    }
  }));
