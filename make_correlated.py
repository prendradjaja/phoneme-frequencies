#!/usr/bin/env python3

import sys

assert len(sys.argv) == 5
_, cmudict_in, kilgarriff_in, correlated_out, uncorrelated_out = sys.argv

cmudict = {}

with open(cmudict_in) as cmudict_file:
    for line in cmudict_file:
        word, *phonemes = line.split()
        cmudict[word.lower()] = phonemes

with open(kilgarriff_in) as kilgarriff_file:
    with open(correlated_out, 'w') as correlated:
        with open(uncorrelated_out, 'w') as uncorrelated:
            for line in kilgarriff_file:
                count_str, word = line.split()
                if word in cmudict:
                    items = [count_str, word] + cmudict[word]
                    correlated.write(' '.join(items) + '\n')
                else:
                    uncorrelated.write(count_str + ' ' + word + '\n')  # can i just write `line`? does it incl. '\n'?
