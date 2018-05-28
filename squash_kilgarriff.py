#!/usr/bin/env python3

import fileinput
import collections

counts = collections.defaultdict(int)

for line in fileinput.input():
    count_str, word = line.split()
    count = int(count_str)

    counts[word] += count

for word in counts:
    print(counts[word], word)
