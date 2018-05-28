#!/usr/bin/env python3

import fileinput
import collections

def post_ws(phonemes):
    for (p, pnext) in zip(phonemes, phonemes[1:]):
        if p is 'w':
            yield pnext

counts = collections.defaultdict(int)

for line in fileinput.input():
    count_str, word, *phonemes = line.split()
    count = int(count_str)
    for p in post_ws(phonemes):
        counts[p] += count

total = sum(count for count in counts.values())

for phoneme, count in sorted(counts.items(),
                             key = lambda x: x[1],
                             reverse = True):
    print(phoneme + '\t' + '{:.2f}'.format(count / total * 100) + '%')
