#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright 2011-2015, Yu-chen Kao (cybeliak)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is copied from https://github.com/cybeliak/mispronounceableness/

""" A small utility to do resegmentation using jieba. """
__author__ = "cybeliak"

import sys
import jieba

import re
import argparse

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("word_list")
    parser.add_argument("--skip", type=int, default=0,
            help="How many columns to be skipped.")
    parser.add_argument("infile", nargs='?',
            type=argparse.FileType('r', encoding='utf-8'),
            default=sys.stdin)
    args = parser.parse_args()

    jieba.set_dictionary(args.word_list)
    jieba.initialize()

    re_ascii_only = re.compile("([\u0021-\u007E]+)", re.U)
    re_space = re.compile("[	 ]+")

    for line in args.infile:
        cols = line.strip().split(" ", args.skip)
        out_blocks = cols[:-1]
        for block in re_ascii_only.split(cols[-1]):
            if not block:
                continue
            if re_ascii_only.match(block):
                out_blocks.append(block)
            else:
                out_blocks.extend(jieba.__cut_DAG_NO_HMM(block))
        sys.stdout.write("%s\n" % (re_space.sub(" ", " ".join(out_blocks))))

if __name__ == '__main__':
    main()
